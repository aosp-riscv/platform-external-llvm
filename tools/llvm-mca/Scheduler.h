//===--------------------- Scheduler.h ------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
///
/// A scheduler for Processor Resource Units and Processor Resource Groups.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_MCA_SCHEDULER_H
#define LLVM_TOOLS_LLVM_MCA_SCHEDULER_H

#include "Instruction.h"
#include "LSUnit.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include <map>

namespace mca {

class Backend;
/// Used to notify the internal state of a processor resource.
///
/// A processor resource is available if it is not reserved, and there are
/// available slots in the buffer.  A processor resource is unavailable if it
/// is either reserved, or the associated buffer is full. A processor resource
/// with a buffer size of -1 is always available if it is not reserved.
///
/// Values of type ResourceStateEvent are returned by method
/// ResourceState::isBufferAvailable(), which is used to query the internal
/// state of a resource.
///
/// The naming convention for resource state events is:
///  * Event names start with prefix RS_
///  * Prefix RS_ is followed by a string describing the actual resource state.
enum ResourceStateEvent {
  RS_BUFFER_AVAILABLE,
  RS_BUFFER_UNAVAILABLE,
  RS_RESERVED
};

/// \brief A descriptor for processor resources.
///
/// Each object of class ResourceState is associated to a specific processor
/// resource. There is an instance of this class for every processor resource
/// defined by the scheduling model.
/// A ResourceState dynamically tracks the availability of units of a processor
/// resource. For example, the ResourceState of a ProcResGroup tracks the
/// availability of resource units which are part of the group.
///
/// Internally, ResourceState uses a round-robin selector to identify
/// which unit of the group shall be used next.
class ResourceState {
  // A resource unique identifier generated by the tool.
  // For processor resource groups, the number of number of bits set in this
  // mask is equivalent to the cardinality of the group plus one.
  // Excluding the most significant bit, the remaining bits in the resource mask
  // identify resources that are part of the group.
  //
  // Example, lets assume that this ResourceState describes a
  // group containing ResourceA and ResourceB:
  //
  //  ResourceA  -- Mask: 0b001
  //  ResourceB  -- Mask: 0b010
  //  ResourceAB -- Mask: 0b100 U (ResourceA::Mask | ResourceB::Mask) == 0b111
  //
  // There is only one bit set for non-group resources.
  // A ResourceMask can be used to solve set membership problems with simple bit
  // manipulation operations.
  uint64_t ResourceMask;

  // A ProcResource can specify a number of units. For the purpose of dynamic
  // scheduling, a processor resource with more than one unit behaves like a
  // group. This field has one bit set for every unit/resource that is part of
  // the group.
  // For groups, this field defaults to 'ResourceMask'. For non-group
  // resources, the number of bits set in this mask is equivalent to the
  // number of units (i.e. field 'NumUnits' in 'ProcResourceUnits').
  uint64_t ResourceSizeMask;

  // A simple round-robin selector for processor resources.
  // Each bit of the mask identifies a sub resource within this group.
  //
  // As an example, lets assume that this ResourceState describes a
  // processor resource group composed of the following three units:
  //   ResourceA -- 0b001
  //   ResourceB -- 0b010
  //   ResourceC -- 0b100
  //
  // Each unit is identified by a ResourceMask which always contains a
  // single bit set. Field NextInSequenceMask is initially set to value
  // 0xb111. That value is obtained by OR'ing the resource masks of
  // processor resource that are part of the group.
  //
  //   NextInSequenceMask  -- 0b111
  //
  // Field NextInSequenceMask is used by the resource manager (i.e.
  // an object of class ResourceManager) to select the "next available resource"
  // from the set. The algorithm would prioritize resources with a bigger
  // ResourceMask value.
  //
  // In this example, there are three resources in the set, and 'ResourceC'
  // has the highest mask value. The round-robin selector would firstly select
  //  'ResourceC', then 'ResourceB', and eventually 'ResourceA'.
  //
  // When a resource R is used, its corresponding bit is cleared from the set.
  //
  // Back to the example:
  // If 'ResourceC' is selected, then the new value of NextInSequenceMask
  // becomes 0xb011.
  //
  // When NextInSequenceMask becomes zero, it is reset to its original value
  // (in this example, that value would be 0b111).
  uint64_t NextInSequenceMask;

  // Some instructions can only be issued on very specific pipeline resources.
  // For those instructions, we know exactly which resource would be consumed
  // without having to dynamically select it using field 'NextInSequenceMask'.
  //
  // The resource mask bit associated to the (statically) selected
  // processor resource is still cleared from the 'NextInSequenceMask'.
  // If that bit was already zero in NextInSequenceMask, then we update
  // mask 'RemovedFromNextInSequence'.
  //
  // When NextInSequenceMask is reset back to its initial value, the algorithm
  // removes any bits which are set in RemoveFromNextInSequence.
  uint64_t RemovedFromNextInSequence;

  // A mask of ready units.
  uint64_t ReadyMask;

  // Buffered resources will have this field set to a positive number bigger
  // than 0. A buffered resource behaves like a separate reservation station
  // implementing its own buffer for out-of-order execution.
  // A buffer of 1 is for units that force in-order execution.
  // A value of 0 is treated specially. In particular, a resource with
  // A BufferSize = 0 is for an in-order issue/dispatch resource.
  // That means, this resource is reserved starting from the dispatch event,
  // until all the "resource cycles" are consumed after the issue event.
  // While this resource is reserved, no other instruction may be dispatched.
  int BufferSize;

  // Available slots in the buffer (zero, if this is not a buffered resource).
  unsigned AvailableSlots;

  // Maximum number of buffer slots seen used during one cycle.
  // This helps tracking dynamic dispatch stalls caused by the lack of
  // entries in the scheduler's queue.
  unsigned MaxUsedSlots;

  // True if this is resource is currently unavailable.
  // An instruction may "reserve" a resource for a number of cycles.
  // During those cycles, the reserved resource cannot be used for other
  // instructions, even if the ReadyMask is set.
  bool Unavailable;

  bool isSubResourceReady(uint64_t ID) const { return ReadyMask & ID; }

  /// Returns the mask identifier of the next available resource in the set.
  uint64_t getNextInSequence() const {
    assert(NextInSequenceMask);
    return llvm::PowerOf2Floor(NextInSequenceMask);
  }

  /// Returns the mask of the next available resource within the set,
  /// and updates the resource selector.
  void updateNextInSequence() {
    NextInSequenceMask ^= getNextInSequence();
    if (!NextInSequenceMask)
      NextInSequenceMask = ResourceSizeMask;
  }

  uint64_t computeResourceSizeMaskForGroup(uint64_t ResourceMask) {
    assert(llvm::countPopulation(ResourceMask) > 1);
    return ResourceMask ^ llvm::PowerOf2Floor(ResourceMask);
  }

public:
  ResourceState(const llvm::MCProcResourceDesc &Desc, uint64_t Mask)
      : ResourceMask(Mask) {
    bool IsAGroup = llvm::countPopulation(ResourceMask) > 1;
    ResourceSizeMask = IsAGroup ? computeResourceSizeMaskForGroup(ResourceMask)
                                : ((1ULL << Desc.NumUnits) - 1);
    NextInSequenceMask = ResourceSizeMask;
    RemovedFromNextInSequence = 0;
    ReadyMask = ResourceSizeMask;
    BufferSize = Desc.BufferSize;
    AvailableSlots = BufferSize == -1 ? 0U : static_cast<unsigned>(BufferSize);
    MaxUsedSlots = 0;
    Unavailable = false;
  }

  uint64_t getResourceMask() const { return ResourceMask; }
  int getBufferSize() const { return BufferSize; }
  unsigned getMaxUsedSlots() const { return MaxUsedSlots; }

  bool isBuffered() const { return BufferSize > 0; }
  bool isInOrder() const { return BufferSize == 1; }
  bool isADispatchHazard() const { return BufferSize == 0; }
  bool isReserved() const { return Unavailable; }

  void setReserved() { Unavailable = true; }
  void clearReserved() { Unavailable = false; }

  // A resource is ready if it is not reserved, and if there are enough
  // available units.
  // If a resource is also a dispatch hazard, then we don't check if
  // it is reserved because that check would always return true.
  // A resource marked as "dispatch hazard" is always reserved at
  // dispatch time. When this method is called, the assumption is that
  // the user of this resource has been already dispatched.
  bool isReady(unsigned NumUnits = 1) const {
    return (!isReserved() || isADispatchHazard()) &&
           llvm::countPopulation(ReadyMask) >= NumUnits;
  }
  bool isAResourceGroup() const {
    return llvm::countPopulation(ResourceMask) > 1;
  }

  bool containsResource(uint64_t ID) const { return ResourceMask & ID; }

  void markSubResourceAsUsed(uint64_t ID) {
    assert(isSubResourceReady(ID));
    ReadyMask ^= ID;
  }

  void releaseSubResource(uint64_t ID) {
    assert(!isSubResourceReady(ID));
    ReadyMask ^= ID;
  }

  unsigned getNumUnits() const {
    return isAResourceGroup() ? 1U : llvm::countPopulation(ResourceSizeMask);
  }

  uint64_t selectNextInSequence();
  void removeFromNextInSequence(uint64_t ID);

  ResourceStateEvent isBufferAvailable() const {
    if (isADispatchHazard() && isReserved())
      return RS_RESERVED;
    if (!isBuffered() || AvailableSlots)
      return RS_BUFFER_AVAILABLE;
    return RS_BUFFER_UNAVAILABLE;
  }

  void reserveBuffer() {
    if (AvailableSlots)
      AvailableSlots--;
    unsigned UsedSlots = static_cast<unsigned>(BufferSize) - AvailableSlots;
    MaxUsedSlots = std::max(MaxUsedSlots, UsedSlots);
  }

  void releaseBuffer() {
    if (BufferSize > 0)
      AvailableSlots++;
    assert(AvailableSlots <= static_cast<unsigned>(BufferSize));
  }

#ifndef NDEBUG
  void dump() const;
#endif
};

/// \brief A resource unit identifier.
///
/// This is used to identify a specific processor resource unit using a pair
/// of indices where the 'first' index is a processor resource mask, and the
/// 'second' index is an index for a "sub-resource" (i.e. unit).
typedef std::pair<uint64_t, uint64_t> ResourceRef;

// First: a resource mask identifying a buffered resource.
// Second: max number of buffer entries used in this resource.
typedef std::pair<uint64_t, unsigned> BufferUsageEntry;

/// A resource manager for processor resource units and groups.
///
/// This class owns all the ResourceState objects, and it is responsible for
/// acting on requests from a Scheduler by updating the internal state of
/// ResourceState objects.
/// This class doesn't know about instruction itineraries and functional units.
/// In future, it can be extended to support itineraries too through the same
/// public interface.
class ResourceManager {
  // The resource manager owns all the ResourceState.
  using UniqueResourceState = std::unique_ptr<ResourceState>;
  llvm::SmallDenseMap<uint64_t, UniqueResourceState> Resources;

  // Keeps track of which resources are busy, and how many cycles are left
  // before those become usable again.
  llvm::SmallDenseMap<ResourceRef, unsigned> BusyResources;

  // A table to map processor resource IDs to processor resource masks.
  llvm::SmallVector<uint64_t, 8> ProcResID2Mask;

  // Adds a new resource state in Resources, as well as a new descriptor in
  // ResourceDescriptor.
  void addResource(const llvm::MCProcResourceDesc &Desc, uint64_t Mask);

  // Compute processor resource masks for each processor resource declared by
  // the scheduling model.
  void computeProcResourceMasks(const llvm::MCSchedModel &SM);

  // Populate resource descriptors.
  void initialize(const llvm::MCSchedModel &SM) {
    computeProcResourceMasks(SM);
    for (unsigned I = 0, E = SM.getNumProcResourceKinds(); I < E; ++I)
      addResource(*SM.getProcResource(I), ProcResID2Mask[I]);
  }

  // Returns the actual resource unit that will be used.
  ResourceRef selectPipe(uint64_t ResourceID);

  void use(ResourceRef RR);
  void release(ResourceRef RR);

  unsigned getNumUnits(uint64_t ResourceID) const {
    assert(Resources.find(ResourceID) != Resources.end());
    return Resources.find(ResourceID)->getSecond()->getNumUnits();
  }

  // Reserve a specific Resource kind.
  void reserveBuffer(uint64_t ResourceID) {
    assert(isBufferAvailable(ResourceID) ==
           ResourceStateEvent::RS_BUFFER_AVAILABLE);
    ResourceState &Resource = *Resources[ResourceID];
    Resource.reserveBuffer();
  }

  void releaseBuffer(uint64_t ResourceID) {
    Resources[ResourceID]->releaseBuffer();
  }

  ResourceStateEvent isBufferAvailable(uint64_t ResourceID) const {
    const ResourceState &Resource = *Resources.find(ResourceID)->second;
    return Resource.isBufferAvailable();
  }

  bool isReady(uint64_t ResourceID, unsigned NumUnits) const {
    const ResourceState &Resource = *Resources.find(ResourceID)->second;
    return Resource.isReady(NumUnits);
  }

public:
  ResourceManager(const llvm::MCSchedModel &SM) { initialize(SM); }

  ResourceStateEvent canBeDispatched(const InstrDesc &Desc) const {
    ResourceStateEvent Result = ResourceStateEvent::RS_BUFFER_AVAILABLE;
    for (uint64_t Buffer : Desc.Buffers) {
      Result = isBufferAvailable(Buffer);
      if (Result != ResourceStateEvent::RS_BUFFER_AVAILABLE)
        break;
    }

    return Result;
  }

  void reserveBuffers(const InstrDesc &Desc) {
    for (const uint64_t R : Desc.Buffers)
      reserveBuffer(R);
  }

  void releaseBuffers(const InstrDesc &Desc) {
    for (const uint64_t R : Desc.Buffers)
      releaseBuffer(R);
  }

  void reserveResource(uint64_t ResourceID) {
    ResourceState &Resource = *Resources[ResourceID];
    assert(!Resource.isReserved());
    Resource.setReserved();
  }

  void releaseResource(uint64_t ResourceID) {
    ResourceState &Resource = *Resources[ResourceID];
    Resource.clearReserved();
  }

  void reserveDispatchHazardResources(const InstrDesc &Desc);

  // Returns true if all resources are in-order, and there is at least one
  // resource which is a dispatch hazard (BufferSize = 0).
  bool mustIssueImmediately(const InstrDesc &Desc);

  bool canBeIssued(const InstrDesc &Desc) const;
  double getRThroughput(const InstrDesc &Desc) const;

  void issueInstruction(
      unsigned Index, const InstrDesc &Desc,
      llvm::SmallVectorImpl<std::pair<ResourceRef, unsigned>> &Pipes);

  void cycleEvent(llvm::SmallVectorImpl<ResourceRef> &ResourcesFreed);

  void getBuffersUsage(std::vector<BufferUsageEntry> &Usage) const {
    for (const std::pair<uint64_t, UniqueResourceState> &Resource : Resources) {
      const ResourceState &RS = *Resource.second;
      if (RS.isBuffered())
        Usage.emplace_back(std::pair<uint64_t, unsigned>(RS.getResourceMask(),
                                                         RS.getMaxUsedSlots()));
    }
  }

  const llvm::ArrayRef<uint64_t> getProcResMasks() const {
    return ProcResID2Mask;
  }

#ifndef NDEBUG
  void dump() const {
    for (const std::pair<uint64_t, UniqueResourceState> &Resource : Resources)
      Resource.second->dump();
  }
#endif
}; // namespace mca

/// Class Scheduler is responsible for issuing instructions to pipeline
/// resources. Internally, it delegates to a ResourceManager the management of
/// processor resources.
/// This class is also responsible for tracking the progress of instructions
/// from the dispatch stage, until the write-back stage.
///
/// An nstruction dispatched to the Scheduler is initially placed into either
/// the 'WaitQueue' or the 'ReadyQueue' depending on the availability of the
/// input operands. Instructions in the WaitQueue are ordered by instruction
/// index. An instruction is moved from the WaitQueue to the ReadyQueue when
/// register operands become available, and all memory dependencies are met.
/// Instructions that are moved from the WaitQueue to the ReadyQueue transition
/// from state 'IS_AVAILABLE' to state 'IS_READY'.
///
/// At the beginning of each cycle, the Scheduler checks if there are
/// instructions in the WaitQueue that can be moved to the ReadyQueue.  If the
/// ReadyQueue is not empty, then older instructions from the queue are issued
/// to the processor pipelines, and the underlying ResourceManager is updated
/// accordingly.  The ReadyQueue is ordered by instruction index to guarantee
/// that the first instructions in the set are also the oldest.
///
/// An Instruction is moved from the ReadyQueue the `IssuedQueue` when it is
/// issued to a (one or more) pipeline(s). This event also causes an instruction
/// state transition (i.e. from state IS_READY, to state IS_EXECUTING).
/// An Instruction leaves the IssuedQueue when it reaches the write-back stage.
class Scheduler {
  const llvm::MCSchedModel &SM;

  // Hardware resources that are managed by this scheduler.
  std::unique_ptr<ResourceManager> Resources;
  std::unique_ptr<LSUnit> LSU;

  // The Backend gets notified when instructions are ready/issued/executed.
  Backend *Owner;

  using QueueEntryTy = std::pair<unsigned, Instruction *>;
  std::map<unsigned, Instruction *> WaitQueue;
  std::map<unsigned, Instruction *> ReadyQueue;
  std::map<unsigned, Instruction *> IssuedQueue;

  void notifyInstructionIssued(
      unsigned Index,
      const llvm::ArrayRef<std::pair<ResourceRef, unsigned>> &Used);
  void notifyInstructionExecuted(unsigned Index);
  void notifyInstructionReady(unsigned Index);
  void notifyResourceAvailable(const ResourceRef &RR);

  /// Issue instructions from the ready queue by giving priority to older
  /// instructions.
  void issue();

  /// Issue an instruction without updating the ready queue.
  void issueInstruction(Instruction *IS, unsigned InstrIndex);
  void updatePendingQueue();
  void updateIssuedQueue();

public:
  Scheduler(Backend *B, const llvm::MCSchedModel &Model, unsigned LoadQueueSize,
            unsigned StoreQueueSize, bool AssumeNoAlias)
      : SM(Model), Resources(llvm::make_unique<ResourceManager>(SM)),
        LSU(llvm::make_unique<LSUnit>(LoadQueueSize, StoreQueueSize,
                                      AssumeNoAlias)),
        Owner(B) {}

  /// Scheduling events.
  ///
  /// The DispatchUnit is responsible for querying the Scheduler before
  /// dispatching new instructions. Queries are performed through method
  /// `Scheduler::CanBeDispatched`, which returns an instance of this enum to
  /// tell if the dispatch would fail or not.  If scheduling resources are
  /// available, and the instruction can be dispatched, then the query returns
  /// HWS_AVAILABLE.  A values different than HWS_AVAILABLE means that the
  /// instruction cannot be dispatched during this cycle.
  ///
  /// Each event name starts with prefix "HWS_", and it is followed by
  /// a substring which describes the reason why the Scheduler was unavailable
  /// (or "AVAILABLE" if the instruction is allowed to be dispatched).
  ///
  /// HWS_QUEUE_UNAVAILABLE is returned if there are not enough available slots
  /// in the  scheduler's queue. That means, one (or more) buffered resources
  /// consumed by the instruction were full.
  ///
  /// HWS_LD_QUEUE_UNAVAILABLE is returned when an instruction 'mayLoad', and
  /// the load queue in the load/store unit (implemented by class LSUnit) is
  /// full.  Similarly, HWS_ST_QUEUE_UNAVAILABLE is returned when the store
  /// queue is full, and the instruction to be dispatched 'mayStore'.
  ///
  /// HWS_DISPATCH_GROUP_RESTRICTION is only returned in special cases where the
  /// instruction consumes an in-order issue/dispatch resource (i.e. a resource
  /// with `BufferSize=0`), and the pipeline resource is not immediately
  /// available.
  enum Event {
    HWS_AVAILABLE,
    HWS_QUEUE_UNAVAILABLE,
    HWS_DISPATCH_GROUP_RESTRICTION,
    HWS_LD_QUEUE_UNAVAILABLE,
    HWS_ST_QUEUE_UNAVAILABLE
  };

  Event canBeDispatched(const InstrDesc &Desc) const;
  Instruction *scheduleInstruction(unsigned Idx, Instruction *MCIS);

  double getRThroughput(const InstrDesc &Desc) const {
    return Resources->getRThroughput(Desc);
  }

  void cycleEvent(unsigned Cycle);

  void getBuffersUsage(std::vector<BufferUsageEntry> &Usage) const {
    Resources->getBuffersUsage(Usage);
  }

  const llvm::ArrayRef<uint64_t> getProcResourceMasks() const {
    return Resources->getProcResMasks();
  }

#ifndef NDEBUG
  void dump() const;
#endif
};

} // Namespace mca

#endif
