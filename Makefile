TEST_DIR = tst
SRC_DIR = src

all :	myc

syntax : lexic	${SRC_DIR}/lang.y
	bison -v -y  -d  ${SRC_DIR}/lang.y
lexic : ${SRC_DIR}/lang.l
	flex ${SRC_DIR}/lang.l


myc : syntax ${SRC_DIR}/Table_des_symboles.c ${SRC_DIR}/Table_des_chaines.c ${SRC_DIR}/Attribute.c ${SRC_DIR}/PCode.c
	gcc -o $@ lex.yy.c y.tab.c ${SRC_DIR}/PCode.c ${SRC_DIR}/Attribute.c ${SRC_DIR}/Table_des_symboles.c ${SRC_DIR}/Table_des_chaines.c -I${SRC_DIR}

clean		:	
	rm -f lex.yy.c *.o y.tab.h y.tab.c *~ ${SRC_DIR}/*~ y.output myc ${TEST_DIR}/*.c ${TEST_DIR}/*~ ${TEST_DIR}/test1[1-3] ${TEST_DIR}/test2[1-2] ${TEST_DIR}/test3[1-2] ${TEST_DIR}/test4[1-4] ${TEST_DIR}/test5[1-4] ${TEST_DIR}/test6[1-2] ${TEST_DIR}/test7[1-2]


#Compile tous les tests
alltest:test1 test2 test3 test4 test5 test6 test7

#Cree les executables de tous les tests
allexec:exec1 exec2 exec3 exec4 exec5 exec6 exec7

#Tests partie 1 : calculs arithmetiques
test11: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec11: test11
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test12: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec12: test12
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test13: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec13: test13
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test1: test11 test12 test13

exec1: exec11 exec12 exec13


#Tests partie 2 : declarations varaibles entieres
test21: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec21: test21
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test22: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec22: test22
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test2: test21 test22

exec2: exec21 exec22


#Tests partie 3 : Conditionnelles (if et if-else)

test31: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec31: test31
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test32: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec32: test32
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test3: test31 test32

exec3: exec31 exec32


#Tests Partie 4 : while

test41: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec41: test41
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test42: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec42: test42
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test43: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec43: test43
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test44: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec44: test44
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test4: test41 test42 test43 test44

exec4: exec41 exec42 exec43 exec44


#Tests Partie 5 : sous-blocs

test51: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec51: test51
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test52: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec52: test52
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test53: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec53: test53
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test54: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec54: test54
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test5: test51 test52 test53 test54

exec5: exec51 exec52 exec53 exec54

#Tests Partie 6 : fonctions

test61: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec61: test61
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test62: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec62: test62
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test6: test61 test62

exec6: exec61 exec62

#Tests Partie 7 : recursivite

test71: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec71: test71
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test72: myc
	./myc ${TEST_DIR}/$@.myc ${TEST_DIR}/$@.c
	cat ${TEST_DIR}/$@.c

exec72: test72
	gcc -Isrc -o ${TEST_DIR}/$< ${TEST_DIR}/$<.c ${SRC_DIR}/PCode.c

test7: test71 test72

exec7: exec71 exec72

