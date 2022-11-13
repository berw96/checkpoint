def bubble_sort(arr):
    # access each element arr[i]
    for i in range(len(arr)):
        # compare jth element to element ahead
        # if arr[j] > arr[j+1], conduct swap
        # else, continue and check next element
        # here "i" tracks no. of remaining elements to scan
        for j in range(0, len(arr)-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
            else:
                continue
    
    print(arr)

def selection_sort(arr):
    # access each element arr[i]
    for i in range(len(arr)):
        # declare an index corresponding to the current minimum value for the pass
        index_of_min = i
        # look at all elements ahead of current minimum
        # if minimum > elem_ahead, set elem_ahead as new minimum
        # else, continue and check next element
        for j in range(i+1, len(arr)):
            if arr[index_of_min] > arr[j]:
                index_of_min = j
            else:
                continue
        
        # once all elements ahead have been checked, conduct swap
        # keep in mind that if no new minimum value is found, we are effectively
        # conducting a swap that does nothing: arr[i] swapped with arr[i]        
        arr[i], arr[index_of_min] = arr[index_of_min], arr[i]
    
    print(arr)

def insertion_sort(arr):
    pass

def merge_sort(arr):
    pass

def radix_sort(arr):
    pass

bubble_sort([2,9,0,-1,55,8,5])
selection_sort([5, 99, 0, 11, 7])
