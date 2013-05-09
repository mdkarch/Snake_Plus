#ifndef _POWBOARD_H_
#define _POWBOARD_H_
#include "constants.h"
int x[X_LEN];
int y[Y_LEN];

int PRNG(int n){
	n_seed = (8253729 * n_seed + + 2396403);
	return n_seed % n;
}

void shuffle(int arr[], int n){
	int i;
	for(i = 0; i < n; i++){
		int index = PRNG(n);
		int temp = arr[index];
		arr[index] = arr[i];
		arr[i] = temp;
	}
}

void shuffle2d(int board[X_LEN][Y_LEN]){
	int arr[1200];
	int i;
	int j;
	int count = 0;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			arr[count] = board[i][j];
			count++;
		}
	}
	shuffle(arr, 1200);
	count = 0;
	for(i = 0; i < X_LEN; i++){
		for(j = 0; j < Y_LEN; j++){
			board[i][j]= arr[count];
			count++;
		}
	}
}

void initPowBoard(int board[X_LEN][Y_LEN], unsigned int seed){
	int i;
	n_seed = seed;
	for (i = 0; i < X_LEN; i++){
		x[i] = i;		
	}
	shuffle(x, X_LEN);
	for (i = 0; i < Y_LEN; i++){
		y[i] = i;				
	}
	shuffle(y, Y_LEN);

	int count = 0;
	i = 0;
	int k;
	int j;
	for(k = 0; k < X_LEN; k++){
		for(j = 0; j < Y_LEN; j++){
			if(i == 4){
				i = 0;
			}
			//printf("%d type: %d at loc: %d,%d\n", count, i, x[k], y[j]);
			board[x[k]][y[j]] = i;
			count++;
			i++;
		}
	}
	shuffle2d(board);
}

#endif
