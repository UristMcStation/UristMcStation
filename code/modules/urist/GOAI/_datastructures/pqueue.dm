#ifdef GOAI_LIBRARY_FEATURES
// only needed in the library as SS13 has the exact same implementation already
// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!list.len) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}
#endif

/*
// PriorityQueue object
// This is the abstract class/interface definition
// Actual usable datastructure impls in subclasses, expected to be full overrides on methods.
*/

#ifdef GOAI_LIBRARY_FEATURES
/PriorityQueue
	var/list/L //the actual queue
	var/cmp //the weight function used to order the queue

/PriorityQueue/New(var/compare)
	return

/PriorityQueue/proc/IsEmpty()
	return TRUE

//add an element in the list,
//immediatly ordering it to its position using dichotomic search
/PriorityQueue/proc/Enqueue(var/A)
	return

//removes and returns the first element in the queue
/PriorityQueue/proc/Dequeue()
	return

//Removes an arbitrary item from the queue
/PriorityQueue/proc/Remove(var/idx)
	return 0

//return the length of the queue
/PriorityQueue/proc/Length()
	return 0
#endif

//Returns the first element in the queue without removing or otherwise mutating the queue
/PriorityQueue/proc/Peek()
	return

/*
// Ordered List/Array Bisection-based PQ
// This is a direct copy of the old SS13 implementation,
// except subclassed for substitutability.
*/

//an ordered list, using the cmp proc to weight the list elements
/PriorityQueue/OrderedList

//removes and returns the first element in the queue
/PriorityQueue/OrderedList/Peek()
	if(!L.len)
		return

	return L[1]

#ifdef GOAI_LIBRARY_FEATURES
// All things here already defined in the base class if SS13 decl is included

/PriorityQueue/OrderedList/New(compare)
	L = list()
	cmp = compare

/PriorityQueue/OrderedList/IsEmpty()
	return !L.len

//add an element in the list,
//immediatly ordering it to its position using dichotomic search
/PriorityQueue/OrderedList/Enqueue(var/A)
	ADD_SORTED(L, A, cmp)

//removes and returns the first element in the queue
/PriorityQueue/OrderedList/Dequeue()
	if(!L.len)
		return
	. = L[1]

	Remove(.)

//removes an element
/PriorityQueue/OrderedList/Remove(var/idx)
	. = L.Remove(idx)

//returns a copy of the elements list
/PriorityQueue/OrderedList/proc/List()
	. = L.Copy()

//return the position of an element or 0 if not found
/PriorityQueue/OrderedList/proc/Seek(var/A)
	. = L.Find(A)

//return the element at the i_th position
/PriorityQueue/OrderedList/proc/Get(i)
	if(i > L.len || i < 1)
		return 0
	return L[i]

//return the length of the queue
/PriorityQueue/OrderedList/Length()
	. = L.len

//replace the passed element at it's right position using the cmp proc
/PriorityQueue/OrderedList/proc/ReSort(var/A)
	var/i = Seek(A)
	if(i == 0)
		return
	while(i < L.len && call(cmp)(L[i],L[i+1]) > 0)
		L.Swap(i,i+1)
		i++
	while(i > 1 && call(cmp)(L[i],L[i-1]) <= 0) //last inserted element being first in case of ties (optimization)
		L.Swap(i,i-1)
		i--
#endif


/*
// classic Binary Heap
//
// For some reason, the SS13 impl above does *not* use a proper BinHeap
// Because this is heavily 'operational', hot code, most of the logic uses Macros From Hell to avoid proc-call overhead
// (although the logic here is plain old function-style logic, just with whitespace escapes and an if(TRUE) added to wrap it up more nicely)
//
// CmpProc should return 0 on equal, -1 if left should be shifted rightwards, +1 if left should be shifted leftwards
// i.e. on a min-heap, 'call(CmpProc)(a, b) = 1' => 'a > b' and '... = -1' => 'a < b'
// (on a max-heap, this is, of course, reversed)
//
// This convention may seem confusing if you think of the call(CmpProc) as a sub in for an operator ('>' or '<');
// this is due to following legacy PQ's convention for ease of integration with old code for time being.
*/

// Basic index arithmetic to find parent/children for a given index
#define BH_PARENT_IDX(ChildIdx) (FLOOR(ChildIdx / 2))
#define BH_LCHILD_IDX(ParentIdx) (2*ParentIdx)
#define BH_RCHILD_IDX(ParentIdx) (1+(2*ParentIdx))

// Sort downwards from root - used for heappop and heapify operations
#define BH_PERCOLATE_DOWN(StartIdx, CmpProc, Heap) if(!isnull(Heap)) {\
	var/__HeapPercolateDown_HeapSize = length(Heap) ;\
	var/__HeapPercolateDown_Idx = StartIdx ;\
	;\
	while(__HeapPercolateDown_Idx <= __HeapPercolateDown_HeapSize) { ;\
		var/__HeapPercolateDown_Largest = __HeapPercolateDown_Idx ;\
		var/__HeapPercolateDown_Left = BH_LCHILD_IDX(__HeapPercolateDown_Idx) ;\
		var/__HeapPercolateDown_Right = BH_RCHILD_IDX(__HeapPercolateDown_Idx) ;\
		;\
		if( (__HeapPercolateDown_Left <= __HeapPercolateDown_HeapSize) && (call(CmpProc)(Heap[__HeapPercolateDown_Left], Heap[__HeapPercolateDown_Largest]) < 0) ) { ;\
			__HeapPercolateDown_Largest = __HeapPercolateDown_Left;\
		} ;\
		;\
		if( (__HeapPercolateDown_Right <= __HeapPercolateDown_HeapSize) && (call(CmpProc)(Heap[__HeapPercolateDown_Right], Heap[__HeapPercolateDown_Largest]) < 0) ) { ;\
			__HeapPercolateDown_Largest = __HeapPercolateDown_Right;\
		} ;\
		;\
		if(__HeapPercolateDown_Largest != __HeapPercolateDown_Idx) { ;\
			Heap.Swap(__HeapPercolateDown_Idx, __HeapPercolateDown_Largest) ;\
			__HeapPercolateDown_Idx = __HeapPercolateDown_Largest ;\
		} ;\
		else { break } ;\
	};\
};

// Sort upwards from a subtree to root - used for heappush operations
#define BH_PERCOLATE_UP(StartIdx, CmpProc, Heap) if(!isnull(Heap)) {\
	var/__HeapPercolate_CurrentIdx = StartIdx ;\
	while(__HeapPercolate_CurrentIdx > 1) {\
		var/__HeapPercolate_HeapParentIdx = BH_PARENT_IDX(__HeapPercolate_CurrentIdx) ;\
		;\
		var/__HeapPercolate_OrderingVal = call(CmpProc)(Heap[__HeapPercolate_HeapParentIdx], Heap[__HeapPercolate_CurrentIdx]) ;\
		if(__HeapPercolate_OrderingVal < 0) { \
			break \
		}\
		Heap.Swap(__HeapPercolate_CurrentIdx, __HeapPercolate_HeapParentIdx) ;\
		__HeapPercolate_CurrentIdx = __HeapPercolate_HeapParentIdx ;\
	}; \
};

// Turns a (non-assoc) list into a heap
// Leaf nodes are already sorted, so we start from the half-size idx
#define BH_HEAPIFY(List, CmpProc) if(!isnull(List)) {\
	var/__Heapify_HeapSize = length(List) ;\
	for(var/idx = FLOOR(__Heapify_HeapSize / 2), idx > 0, idx--) {;\
		BH_PERCOLATE_DOWN(idx, CmpProc, List) ;\
	} ;\
};


// Adds a new element to the heap in the appropriate location,
// shuffling the rest as needed
#define BH_HEAPPUSH(Elem, CmpProc, Heap) if(!isnull(Heap)) {\
	Heap.len++; Heap[Heap.len] = Elem ;\
	BH_PERCOLATE_UP(Heap.len, CmpProc, Heap) ;\
};


// Removes an arbitrary element from the heap an shuffles
// the rest of the items into their correct locations.
#define BH_DELETE(Idx, CmpProc, Heap) if(Heap) {\
	var/__Bhdelete_DeletedIdx = Heap[Idx] ;\
	var/__Bhdelete_OldLast = Heap[Heap.len] ;\
	Heap[Idx] = __Bhdelete_OldLast ;\
	Heap.len-- ;\
	var/__Bhdelete_Comparison = call(CmpProc)(__Bhdelete_OldLast, __Bhdelete_DeletedIdx) ;\
	if(__Bhdelete_Comparison != 0) {;\
		if(__Bhdelete_Comparison < 0) { BH_PERCOLATE_DOWN(Idx, CmpProc, Heap) } ;\
		else { BH_PERCOLATE_UP(Idx, CmpProc, Heap) }; \
	}; \
};


// Removes and RETURNS the *root* element from the heap
// (i.e. min-value for min-heap or max-value for max-heap)
// and shuffles the rest of the items into their correct locations
// The VarName arg should hold the variable to put the root value into.
#define BH_HEAPPOP(VarName, CmpProc, Heap) if(Heap) {\
	##VarName = Heap[1] ;\
	Heap[1] = Heap[Heap.len] ;\
	Heap.len-- ;\
	if(Heap) { BH_PERCOLATE_DOWN(1, CmpProc, Heap) };\
};
// this ^ could technically just reuse the DELETE operation,
// but we can optimize away the comparison in the heappop case


// Returns the top (min for min-heap, max for max-heap) element
// without mutating the heap in any way.
// The VarName arg should hold the variable to put the value into.
#define BH_HEAPPEEK(VarName, CmpProc, Heap) if(Heap) {\
	##VarName = Heap[1] ;\
};



/proc/BHeapPush(var/elem, var/cmp, var/list/heap = null) // -> list (updated or created heap)
	// Proc version of the BH_HEAPPUSH() macro.
	// Slower, but creates the list if needed and could be backgrounded.
	var/list/_heap = heap

	if(!istype(heap))
		_heap = list()

	_heap.Add(elem)

	BH_HEAPPUSH(elem, cmp, _heap)
	return _heap


/proc/BHeapPop(var/cmp, var/list/heap)
	var/list/_heap = heap

	if(!istype(_heap))
		return null

	var/root
	BH_HEAPPOP(root, cmp, heap)
	return root


/proc/Heapify(var/list/L, var/cmp)
	if(!istype(L))
		return

	if(!L)
		return L

	BH_HEAPIFY(L, cmp)
	return L


/proc/BhTestBasicMin(var/A, var/B)
	var/Anull = isnull(A)
	var/Bnull = isnull(B)

	if(Anull && Bnull)
		return 0

	if(Anull)
		return -1

	if(Bnull)
		return 1

	if(A > B)
		return 1

	if(A < B)
		return -1

	return 0


/proc/BhTestBasicMax(var/A, var/B)
	var/Anull = isnull(A)
	var/Bnull = isnull(B)

	if(Anull && Bnull)
		return 0

	if(Anull)
		return 1

	if(Bnull)
		return -1

	if (A > B)
		return -1

	if(A < B)
		return 1

	return 0


/PriorityQueue/BinHeap
	// beam search support - trim the queue to a max size, discarding tail results
	var/capacity_cap = null


/PriorityQueue/BinHeap/New(var/compare, var/list/initial_data = null, var/capacity = null)
	// Constructor, returns a new PQ based on a BinHeap. Args:
	// - compare: a proc that takes exactly two required positional arguments ('A' & 'B') of any type and returns an ordering (-1 if A<B, 1 if A>B, 0 if A=B)
	// - initial_data: optional non-assoc list; data to put on

	// Bind the comparison proc...
	src.cmp = compare
	ASSERT(!isnull(src.cmp)) // must be initialized guard

	// ...and the data, if any.
	if(istype(initial_data))
		src.L = initial_data.Copy()
		BH_HEAPIFY(src.L, src.cmp)

	else
		if(capacity && (capacity > 0))
			var/newheap[capacity]
			src.L = newheap
		else
			src.L = list()

	return

/PriorityQueue/BinHeap/IsEmpty()
	return ((length(src.L) || 0) <= 0)


/PriorityQueue/BinHeap/Enqueue(var/A)
	BH_HEAPPUSH(A, src.cmp, src.L)
	var/len_cap = (src.capacity_cap || 0)
	if(len_cap > 0)
		while(length(src.L) > len_cap)
			src.L.len--
	return src


/PriorityQueue/BinHeap/Dequeue()
	if(!src.L.len)
		return

	var/popped
	BH_HEAPPOP(popped, src.cmp, src.L)
	return popped


/PriorityQueue/BinHeap/Peek()
	// Like Dequeue, but non-destructive - just returns the root element.
	// if you JUST want the max of a list and will throw away the tail,
	// this method should be much faster.
	var/peeked
	BH_HEAPPEEK(peeked, src.cmp, src.L)
	return peeked


/PriorityQueue/BinHeap/Remove(var/idx)
	if(!src.L)
		return 0

	BH_DELETE(idx, src.cmp, src.L)
	return 1


//return the length of the queue
/PriorityQueue/BinHeap/Length()
	. = L.len

