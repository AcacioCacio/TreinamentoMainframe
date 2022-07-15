      *=============================================================*   00001001
       IDENTIFICATION                            DIVISION.              00002001
      *=============================================================*   00003001
                                                                        00004001
       PROGRAM-ID. FR09DB13.                                            00005001
       AUTHOR.     ACACIO.                                              00005101
                                                                        00006001
      *================================================================*00007001
      *                        TREINAMENTO                             *00008001
      *================================================================*00009001
      *     PROGRAMA....: FR09DB13                                     *00010001
      *     PROGRAMADOR.: ACACIO JORGE                                 *00011001
      *     INSTRUTOR...: IVAN SANCHES                                 *00011101
      *     EMPRESA.....: FOURSYS                                      *00011201
      *     DATA........: 13/06/2022                                   *00011301
      *----------------------------------------------------------------*00011401
      *     OBJETIVO....: USO DE SYNCPOINTNA TABELA USANDO CHECK       *00011501
      *                                                                *00011601
      *----------------------------------------------------------------*00011701
      *                                                                *00011801
      *     ARQUIVOS....:                                              *00011901
      *       DDNAME               I/O                 INCLUDE/BOOK    *00012001
      *                                                                *00012101
      *                                                                *00012201
      *----------------------------------------------------------------*00012301
      *                                                                *00012401
      *     BASE DE DADOS:                                             *00012501
      *       DDNAME               I/O                 INCLUDE/BOOK    *00012601
      *       FOU001.FUNC           I                    D#FUNC        *00012701
      *       FOU001.CHECK          I                    #BKCHECK      *00012801
      *                                                                *00012901
      *----------------------------------------------------------------*00013001
      *                                                                *00013101
      *     MODULOS.....:                                              *00013201
      *       B#GLOB                                                   *00013301
      *                                                                *00013401
      *================================================================*00013501
                                                                        00013601
      *=============================================================*   00013701
       ENVIRONMENT                               DIVISION.              00014001
      *=============================================================*   00015001
                                                                        00015101
      *-------------------------------------------------------------*   00015201
       CONFIGURATION                               SECTION.             00015301
      *-------------------------------------------------------------*   00015401
       SPECIAL-NAMES.                                                   00015501
           DECIMAL-POINT IS COMMA.                                      00015601
                                                                        00015701
      *=============================================================*   00015801
       DATA                                      DIVISION.              00015901
      *=============================================================*   00016001
                                                                        00017001
      *-------------------------------------------------------------*   00018001
       WORKING-STORAGE                             SECTION.             00019001
      *-------------------------------------------------------------*   00020001
                                                                        00020101
      *----------------------------------------------------------------*00020201
       01  FILLER                      PIC  X(050)         VALUE        00020302
           '*** INICIO DA WORKING FR09DB13 ***'.                        00020402
      *----------------------------------------------------------------*00020501
                                                                        00020601
      *----------------------------------------------------------------*00020701
       01  FILLER                                  PIC X(050)    VALUE  00020802
           '*** AREA DE DB2 ***'.                                       00020902
      *----------------------------------------------------------------*00021001
                                                                        00021101
           EXEC SQL                                                     00021201
             INCLUDE #BKFUNC2                                           00021301
           END-EXEC.                                                    00021401
                                                                        00021601
           EXEC SQL                                                     00021701
             INCLUDE #BKCHECK                                           00021801
           END-EXEC.                                                    00021901
                                                                        00022001
           EXEC SQL                                                     00022101
              INCLUDE SQLCA                                             00022201
           END-EXEC.                                                    00022301
                                                                        00022401
           EXEC SQL                                                     00022501
              DECLARE CFUNC  CURSOR FOR                                 00022602
               SELECT ID,NOME,SETOR,SALARIO,DATAADM,EMAIL               00022701
                FROM FOUR001.FUNC2  WHERE ID >=                         00022801
                  (SELECT REGISTRO FROM FOUR001.CHECK                   00022901
                      WHERE IDCHECK = 'FOUR009' )                       00023001
               ORDER BY ID                                              00023101
                                                                        00023201
           END-EXEC.                                                    00023301
                                                                        00024201
      *----------------------------------------------------------------*00024301
       01  FILLER                                  PIC X(050)    VALUE  00024402
           '*** AREA DO ARQUIVO LOGERRO2 ***'.                          00024502
      *----------------------------------------------------------------*00024601
                                                                        00024701
          COPY 'B#GLOB'.                                                00024801
                                                                        00024901
      *----------------------------------------------------------------*00025001
                                                                        00025101
      *----------------------------------------------------------------*00025201
       01  FILLER                                  PIC X(050)    VALUE  00025302
           '*** AREA DE VARIAVEIS AUXILIARES ***'.                      00025402
      *----------------------------------------------------------------*00025501
                                                                        00025601
       77 WRK-ID                  PIC 9(04).                            00025701
       77 WRK-SQLCODE             PIC -999.                             00025801
       77 WRK-INDICATOR           PIC S9(4) COMP            VALUE ZEROS.00025901
       77 WRK-CHECKPOINT          PIC 9(2)                  VALUE ZEROS.00026001
       77 WRK-REGATUAL            PIC 9(3)                  VALUE ZEROS.00026201
                                                                        00026301
      *----------------------------------------------------------------*00026401
       01  FILLER                      PIC  X(050)         VALUE        00026502
           '*** AREA DE ACUMULADORES ***'.                              00026602
      *----------------------------------------------------------------*00026701
                                                                        00026801
       77 ACU-LIDOS               PIC 9(02)                 VALUE ZEROS.00026901
       77 ACU-GRAVS               PIC 9(02)                 VALUE ZEROS.00027001
                                                                        00027101
      *----------------------------------------------------------------*00027201
       01  FILLER                 PIC  X(050)         VALUE             00027302
           '*** FINAL DA WORKING FR09DB13 ***'.                         00027402
      *----------------------------------------------------------------*00027501
                                                                        00027601
      *================================================================*00027701
       PROCEDURE                                 DIVISION.              00027801
      *================================================================*00027901
                                                                        00028001
      ******************************************************************00028101
      *                      P R I N C I P A L                         *00028201
      ******************************************************************00028301
                                                                        00028401
      *----------------------------------------------------------------*00028501
       0000-PRINCIPAL                                 SECTION.          00028601
      *----------------------------------------------------------------*00028701
                                                                        00028801
           PERFORM 1000-INICIAR.                                        00028901
           PERFORM 2000-PROCESSAR                                       00029001
                        UNTIL SQLCODE EQUAL 100.                        00029101
           PERFORM 3000-FINALIZAR.                                      00029201
           STOP RUN.                                                    00029301
                                                                        00029401
      *----------------------------------------------------------------*00029501
       0000-99-FIM.                                   EXIT.             00029601
      *----------------------------------------------------------------*00029701
                                                                        00029801
      ******************************************************************00029901
      *                    I N I C I A L I Z A R                       *00030001
      ******************************************************************00030101
                                                                        00030201
      *----------------------------------------------------------------*00030301
       1000-INICIAR                                   SECTION.          00030401
      *----------------------------------------------------------------*00030501
                                                                        00030601
            EXEC SQL                                                    00030701
               OPEN CFUNC                                               00030802
            END-EXEC.                                                   00030901
                                                                        00031001
             EVALUATE SQLCODE                                           00031101
              WHEN 0                                                    00031201
                PERFORM 1100-LER-FUNCIONARIO                            00031301
                                                                        00031401
              WHEN 100                                                  00031501
                DISPLAY '*============================================*'00031601
                DISPLAY '* FUNCIONARIO..: SEM FUNCIONARIOS            *'00031701
                DISPLAY '*============================================*'00031801
                                                                        00031901
              WHEN OTHER                                                00032001
                MOVE SQLCODE TO WRK-SQLCODE                             00032101
                DISPLAY 'ERRO ' WRK-SQLCODE ' NO OPEN CURSOR'           00032201
                GOBACK                                                  00032301
              END-EVALUATE.                                             00032401
                                                                        00032501
      *----------------------------------------------------------------*00032601
       1000-99-FIM.                                   EXIT.             00032701
      *----------------------------------------------------------------*00032801
                                                                        00032901
      *----------------------------------------------------------------*00033001
       1100-LER-FUNCIONARIO                                  SECTION.   00033101
      *----------------------------------------------------------------*00033201
                                                                        00033301
           EXEC SQL                                                     00033401
             FETCH CFUNC                                                00033501
              INTO :DB2-ID,                                             00033601
                   :DB2-NOME,                                           00033701
                   :DB2-SETOR,                                          00033801
                   :DB2-SALARIO,                                        00033901
                   :DB2-DATAADM,                                        00034001
                   :DB2-EMAIL     :WRK-INDICATOR                        00034101
           END-EXEC.                                                    00034201
                                                                        00034301
                                                                        00034401
                                                                        00034501
           EVALUATE SQLCODE                                             00034601
            WHEN 0                                                      00034701
                ADD 1 TO ACU-LIDOS                                      00034801
                ADD 1 TO WRK-REGATUAL                                   00034901
                CONTINUE                                                00035001
                                                                        00035101
            WHEN 100                                                    00035201
              DISPLAY '*==============================================*'00035301
              DISPLAY '* FINAL DA TABELA                              *'00035401
              DISPLAY '*==============================================*'00035501
                                                                        00035601
            WHEN OTHER                                                  00035701
              MOVE SQLCODE TO WRK-SQLCODE                               00035801
              DISPLAY '*==============================================*'00035901
              DISPLAY '* ERRO ....: ' WRK-SQLCODE                       00036001
              DISPLAY '*==============================================*'00036101
           END-EVALUATE.                                                00036201
                                                                        00036301
      *----------------------------------------------------------------*00036401
       1100-99-FIM.                                   EXIT.             00036501
      *----------------------------------------------------------------*00036601
                                                                        00036701
      ******************************************************************00036801
      *                      P R O C E S S A R                         *00036901
      ******************************************************************00037001
                                                                        00037101
      *----------------------------------------------------------------*00037201
       2000-PROCESSAR                                        SECTION.   00037301
      *----------------------------------------------------------------*00037401
                                                                        00037501
              PERFORM 2100-DISPLAY.                                     00037601
                                                                        00037701
      *         IF ACU-LID0S > 5                                        00037801
      *           EXEC SQL                                              00037901
      *              COMMIT                                             00038001
      *           END-EXEC                                              00038101
      *            MOVE 0 TO ACU-LIDOS                                  00038201
      *         END-IF                                                  00038301
                                                                        00038401
      *       IF DB2-SALARIO IS NOT NUMERIC OR DB2-SALARIO EQUAL ZEROS  00038501
              IF DB2-SALARIO IS NOT NUMERIC OR DB2-SALARIO EQUAL 99999  00038601
                 EXEC SQL                                               00038701
                    UPDATE FOUR001.CHECK SET REGISTRO = :DB2-ID         00038801
                     WHERE IDCHECK = 'FOUR009'                          00038901
                 END-EXEC                                               00039001
                 PERFORM 3000-FINALIZAR                                 00039101
                 GOBACK                                                 00039201
               END-IF                                                   00039301
                                                                        00039401
               PERFORM 1100-LER-FUNCIONARIO.                            00039501
                                                                        00039601
      *----------------------------------------------------------------*00039701
       2000-99-FIM.                                   EXIT.             00039801
      *----------------------------------------------------------------*00039901
                                                                        00040001
      ******************************************************************00040101
      *                         D I S P L A Y                          *00040201
      ******************************************************************00040301
                                                                        00040401
      *----------------------------------------------------------------*00040501
       2100-DISPLAY                                   SECTION.          00040601
      *----------------------------------------------------------------*00040701
                                                                        00040801
           DISPLAY '*-------------------------------------------------*'00040901
           DISPLAY '*              INFORMACOES DO DADO                *'00041001
           DISPLAY '*-------------------------------------------------*'00041101
           DISPLAY '*                                                 *'00041201
           DISPLAY '* ID.......: ' DB2-ID                               00041301
           DISPLAY '* NOME.....: ' DB2-NOME                             00041401
           DISPLAY '* SETOR....: ' DB2-SETOR                            00041501
           DISPLAY '* SALARIO..: ' DB2-SALARIO                          00041601
           DISPLAY '* DATAADM..: ' DB2-DATAADM                          00041701
           IF WRK-INDICATOR = 0                                         00041801
              DISPLAY '* EMAIL....: ' DB2-EMAIL                         00041901
           ELSE                                                         00042001
              DISPLAY '* EMAIL....: SEM EMAIL                         *'00042101
           END-IF.                                                      00042201
           DISPLAY '*                                                 *'00042301
           DISPLAY '*-------------------------------------------------*'00042401
           DISPLAY '*              INFORMACOES DO DADO                *'00042501
           DISPLAY '*-------------------------------------------------*'00042601
           DISPLAY ' -- '.                                              00042701
                                                                        00043301
      *----------------------------------------------------------------*00043401
       2100-99-FIM.                                   EXIT.             00043501
      *----------------------------------------------------------------*00043601
                                                                        00043701
      ******************************************************************00043801
      *                      F I N A L I Z A R                         *00043901
      ******************************************************************00044001
                                                                        00044101
      *----------------------------------------------------------------*00044201
       3000-FINALIZAR                                        SECTION.   00044301
      *----------------------------------------------------------------*00044401
                                                                        00044501
           IF ACU-LIDOS           GREATER ZEROS                         00044601
              PERFORM 4000-EMITIR-ACU                                   00044701
           END-IF                                                       00044801
                                                                        00044901
           EXEC SQL                                                     00045001
             CLOSE CFUNC                                                00045102
           END-EXEC.                                                    00045201
                                                                        00045301
      *----------------------------------------------------------------*00045701
       3000-99-FIM.          EXIT.                                      00045801
      *----------------------------------------------------------------*00045901
                                                                        00046001
      ******************************************************************00046101
      *               E M I T I R   A C U M U L A D O R E S            *00046201
      ******************************************************************00046301
                                                                        00046401
      *----------------------------------------------------------------*00046501
       4000-EMITIR-ACU                           SECTION.               00046601
      *----------------------------------------------------------------*00046701
                                                                        00046801
           DISPLAY '*=================== FR09DB13 ====================*'00046902
           DISPLAY '*                                                 *'00047001
           DISPLAY '* ACUMULADORES:                                   *'00047101
           DISPLAY '* LIDOS..............: ' ACU-LIDOS                  00047202
           DISPLAY '* GRAVADOS...........: ' ACU-GRAVS                  00047302
           DISPLAY '*                                                 *'00048001
           DISPLAY '*=================== FR09DB13 ====================*'00050002
           DISPLAY ' '.                                                 00060001
                                                                        00070001
      *----------------------------------------------------------------*00080001
       4000-99-FIM.                              EXIT.                  00090001
      *----------------------------------------------------------------*00100001
                                                                        00101001
      ******************************************************************00110001
      *                     T R A T A R   E R R O                      *00120001
      ******************************************************************00130001
                                                                        00140001
      *----------------------------------------------------------------*00150001
       9000-TRATAR-ERRO                          SECTION.               00160001
      *----------------------------------------------------------------*00170001
                                                                        00180001
           CALL 'GRAVALOG'                       USING WRK-LOG          00190001
           GOBACK.                                                      00200001
                                                                        00210001
      *----------------------------------------------------------------*00220001
       9000-99-FIM.                              EXIT.                  00230001
      *----------------------------------------------------------------*00240001
