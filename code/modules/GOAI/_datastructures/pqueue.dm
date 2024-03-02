/*
  Ripped off from SS13.

  This implementation relies on the built-in list() type, which *acts* like a dynamic array.
  Since a PQ needs to do a bunch of left-pops, this may be inefficient, depending on how DM
  lists work - if it's a plain old dynarray, each Remove(idx) needs to shift (len-idx) entries.

  As such, it might be good to implement a Binary Search Tree datum and port the PQ to use that
  instead at some point in the future since PQs will be in the hot path of AI code frequently.
*/
// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!list.len) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}


//////////////////////
//PriorityQueue object
//////////////////////

//an ordered list, using the cmp proc to weight the list elements
/PriorityQueue
	var/list/L //the actual queue
	var/cmp //the weight function used to order the queue

/PriorityQueue/New(compare)
	L = new()
	cmp = compare

/PriorityQueue/proc/IsEmpty()
	return !L.len

//add an element in the list,
//immediatly ordering it to its position using dichotomic search
/PriorityQueue/proc/Enqueue(var/A)
	ADD_SORTED(L, A, cmp)

//removes and returns the first element in the queue
/PriorityQueue/proc/Dequeue()
	if(!L.len)
		return 0
	. = L[1]

	Remove(.)

//removes an element
/PriorityQueue/proc/Remove(var/A)
	. = L.Remove(A)

//returns a copy of the elements list
/PriorityQueue/proc/List()
	. = L.Copy()

//return the position of an element or 0 if not found
/PriorityQueue/proc/Seek(var/A)
	. = L.Find(A)

//return the element at the i_th position
/PriorityQueue/proc/Get(i)
	if(i > L.len || i < 1)
		return 0
	return L[i]

//return the length of the queue
/PriorityQueue/proc/Length()
	. = L.len

//replace the passed element at it's right position using the cmp proc
/PriorityQueue/proc/ReSort(var/A)
	var/i = Seek(A)
	if(i == 0)
		return
	while(i < L.len && call(cmp)(L[i],L[i+1]) > 0)
		L.Swap(i,i+1)
		i++
	while(i > 1 && call(cmp)(L[i],L[i-1]) <= 0) //last inserted element being first in case of ties (optimization)
		L.Swap(i,i-1)
		i--
