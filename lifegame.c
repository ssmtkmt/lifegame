#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define N 20
#define MAXGEN 20
#define NORMALIZE(x,s) ((x + s) % s)

typedef struct {
	int size;
	char board[N][N];
} Lifegame;

int countAlive(Lifegame *lg, int x, int y){
	int x_minus = NORMALIZE(x-1, lg->size);
	int y_minus = NORMALIZE(y-1, lg->size);
	int x_plus = NORMALIZE(x+1, lg->size);
	int y_plus = NORMALIZE(y+1, lg->size);
	return lg->board[x_minus][y_minus] + lg->board[x_minus][y] + lg->board[x_minus][y_plus] +
	       lg->board[x][y_minus] + lg->board[x][y_plus] +
	       lg->board[x_plus][y_minus] + lg->board[x_plus][y] + lg->board[x_plus][y_plus];
}

char isAlive(Lifegame *lg, int x, int y){
	int nr_alive = countAlive(lg, x, y);
	if(lg->board[x][y] &&
	   nr_alive != 2 && nr_alive != 3){
		return 0;
	}
	if(!lg->board[x][y] && nr_alive == 3){
		return 1;
	}
	return lg->board[x][y];
}

Lifegame *newGeneration(Lifegame *lg){
	int x,y;
	char buf[lg->size][lg->size];
	for(x = 0; x < lg->size; x++){
		for(y = 0; y < lg->size; y++){
			buf[x][y] = isAlive(lg, x, y);
		}
	}
	memcpy(lg->board, buf, lg->size * lg->size);
	return lg;
}

void printBoard(Lifegame *lg){
	int x, y;
	for(x = 0; x < lg->size; x++){
		for(y = 0; y < lg->size; y++){
			putchar(lg->board[x][y]?'*':' ');
		}
		putchar('\n');
	}
	putchar('\n');
}

void init(Lifegame *lg){
	lg->size = N;
	int x,y;
	srand((unsigned int)time(NULL));
	for(x = 0; x < N/2; x++){
		for(y = 0; y < N/2; y++){
			lg->board[x][y] = (char)rand() % 2;
		}
	}
}

int main(){
	Lifegame lifegame;
	unsigned int tick = 0;
	init(&lifegame);
	while(tick++ < MAXGEN){
		newGeneration(&lifegame);
		printBoard(&lifegame);
		sleep(1);
	}
	return 0;
}
