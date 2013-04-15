#ifndef _LIST_H_
#define _LIST_H_

/*
* A node in a linked list.
*/
struct Node {
    void *data;
    struct Node *next;
};

/*
* A linked list.
* 'head' points to the first node in the list.
*/
struct List {
    struct Node *head;
};

/*
* Initialize an empty list.
*/
static inline void initList(struct List *list)
{
    list->head = 0;
}

/*
* In all functions below, the 'list' parameter is assumed to point to
* a valid List structure.
*/

/*
* Create a node that holds the given data pointer,
* and add the node to the front of the list.
*
* Note that this function does not manage the lifetime of the object
* pointed to by 'data'.
*
* It returns the newly created node on success and NULL on failure.
*/
struct Node *addFront(struct List *list, void *data)
{
	struct Node *temp;
	temp = (struct Node *)malloc(sizeof(struct Node));
	if (temp == NULL )
	{
		perror("malloc returned NULL");
		return NULL;
	}else
	{
		temp->data = data;
		if(list->head == NULL)
		{
			list->head = temp;
			temp->next = NULL;
		}else
		{
			temp->next = list->head;
			list->head = temp;
		}

		return temp;
	}
};

/*
* Traverse the list, calling f() with each data item.
*/
void traverseList(struct List *list, void (*f)(void *))
{
struct Node *curr_p;
curr_p = list->head;

while(curr_p != NULL)
{
f(curr_p->data);
curr_p = curr_p->next;

}
};

/*
* Traverse the list, comparing each data item with 'dataSought' using
* 'compar' function. ('compar' returns 0 if the data pointed to by
* the two parameters are equal, non-zero value otherwise.)
*
* Returns the first node containing the matching data,
* NULL if not found.
*/
struct Node *findNode(struct List *list, const void *dataSought,
int (*compar)(const void *, const void *))
{
struct Node *curr_p;
struct Node *temp = NULL;
curr_p = list->head;

while(curr_p != NULL)
{
if(compar(curr_p->data, dataSought) == 0)
{
temp = curr_p;
curr_p = curr_p->next;
}else
{
curr_p = curr_p->next;
}
}

if(temp != NULL)
{
return temp;
}else
{
return NULL;
}
};

/*
* Flip the sign of the double value pointed to by 'data' by
* multiplying -1 to it and putting the result back into the memory
* location.
*/
void flipSignDouble(void *data)
{
double *temp;
temp = (double*)data;
*temp = (*temp) * (-1.0);
data = (void*)temp;
};

/*
* Compare two double values pointed to by the two pointers.
* Return 0 if they are the same value, 1 otherwise.
*/
int compareDouble(const void *data1, const void *data2)
{
double tempData1 = *(double*)data1;
double tempData2 = *(double*)data2;

if(tempData1 == tempData2)
{
return 0;
}else
{
return 1;
}
};

/*
* Returns 1 if the list is empty, 0 otherwise.
*/
//static inline int isEmptyList(struct List *list)
//{
  // return (list->head == 0);
//}

/*
* Remove the first node from the list, deallocate the memory for the
* ndoe, and return the 'data' pointer that was stored in the node.
* Returns NULL is the list is empty.
*/


void *popFront(struct List *list)
{

if(list->head != NULL)
{
struct Node *curr_p;
void *temp;
curr_p = list->head;
list->head = curr_p->next;
temp = curr_p->data;

free(curr_p);

return temp;
}else
{
return NULL;
}

};

/*
* Remove all nodes from the list, deallocating the memory for the
* nodes. You can implement this function using popFront().
*/
void removeAllNodes(struct List *list)
{
while(list->head != NULL)
{
popFront(list);
}
};

/*
* Create a node that holds the given data pointer,
* and add the node right after the node passed in as the 'prevNode'
* parameter. If 'prevNode' is NULL, this function is equivalent to
* addFront().
*
* Note that prevNode, if not NULL, is assumed to be one of the nodes
* in the given list. The behavior of this function is undefined if
* prevNode does not belong in the given list.
*
* Note that this function does not manage the lifetime of the object
* pointed to by 'data'.
*
* It returns the newly created node on success and NULL on failure.
*/
struct Node *addAfter(struct List *list,
struct Node *prevNode, void *data)
{
if(prevNode == NULL)

{
prevNode = addFront(list, data);
return prevNode;
}else
{
struct Node *temp;
temp = (struct Node *)malloc(sizeof(struct Node));
if (temp == NULL )
{
perror("malloc returned NULL");
return NULL;
}

temp->data = data;
temp->next = prevNode->next;
prevNode->next = temp;
return temp;
}
};

/*
* Reverse the list.
*
* Note that this function reverses the list purely by manipulating
* pointers. It does NOT call malloc directly or indirectly (which
* means that it does not call addFront() or addAfter()).
*
* Implementation hint: keep track of 3 consecutive nodes (previous,
* current, next) and move them along in a while loop. Your function
* should start like this:


struct Node *prv = NULL;
struct Node *cur = list->head;
struct Node *nxt;

while (cur) {
......


* And at the end, prv will end up pointing to the first element of
* the reversed list. Don't forget to assign it to list->head.
*/
void reverseList(struct List *list)
{
struct Node *prv = NULL;
struct Node *cur = list->head;
struct Node *nxt;

/*
-here nxt is a place holder for the previous node
-prv points to what the current pointer is pointing to so as not to lose track of the list
-to move down the list current pointer is now equal to current next node
-then prv's next points to what was held by nxt do as to reverse the list
-then to go the whole list, the head of the list now becomes the beginning of the reversd list
*/
while(cur)
{
nxt = prv;
prv = cur;
cur = cur->next;
prv->next = nxt;
}

list->head = prv;
}


;

#endif /* #ifndef _LIST_H_ */
