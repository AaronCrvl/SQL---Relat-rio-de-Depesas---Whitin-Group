-- Relatório Customizado EVIDA - Detalhamento das Despesas de Empresas
-- Relatório específico na EVIDA, a view vw_prest_espm foi criada para unir todas as especialidades dos preatdores em uma única tabela.
-- Caso rodar em outro cliente apresenta erro se não tiver a view criada.

-- Versão 1: Foco em IM_VTNC e datas de liberação.
SELECT DISTINCT B.COD_PLANO,
                DECODE(F.PREPGTO, 'F', 'POS-PGTO', 'PRE-PGTO') CATEGORIA,
                C.NOME NOME_PREST,
                C.CODIGO,
                NVL(C.CPF, C.CNPJ) AS "CPF/CNPJ",
                B.COD_SEG,
                B.NOME NOME_BENEF,
                B.CPF,
                LISTAGG(D.COD_ESPM, '; ') WITHIN GROUP(ORDER BY D.COD_ESPM) "COD_ESPM",
                A.COD_SERV COD_SERV,
                (A.VALOR - A.VALOR_GLOSADO) AS TOTAL,
                DECODE(C.CLINICA, 'F', 'HOSPITAL', 'CLÍNICA') AS LOCAL_,
                A.DT_LIB DT_LIB
  FROM IM_VTCN1      A,
       IM_SEG        B,
       VW_PRESTADOR  C,
       VW_PREST_ESPM D,
       IM_ESPM       E,
       IM_PLANO      F
 WHERE A.COD_SEG = B.COD_SEG(+)
   AND A.COD_ENT = C.CODIGO(+)
   AND C.CODIGO = D.COD(+)
   AND D.COD_ESPM = E.COD_ESPM(+)
   AND B.COD_PLANO = F.COD_PLANO(+)
   AND B.COD_SET = &EMPRESA
   AND SUBSTR(A.MES_PGTO, 0, 7) = '&ANO_MES'
 GROUP BY B.COD_PLANO,
          DECODE(F.PREPGTO, 'F', 'POS-PGTO', 'PRE-PGTO'),
          C.NOME,
          C.CODIGO,
          NVL(C.CPF, C.CNPJ),
          B.COD_SEG,
          B.NOME,
          B.CPF,
          A.COD_SERV,
          (A.VALOR - A.VALOR_GLOSADO),
          DECODE(C.CLINICA, 'F', 'HOSPITAL', 'CLÍNICA'),
          A.DT_LIB
 ORDER BY COD_PLANO, NOME_PREST, B.COD_SEG, DT_LIB;
 
 
-- Versão 2 : Adição da VW_SERVICOS x IM_VTCN1 para verificação de data de realização do serviço.
SELECT DISTINCT B.COD_PLANO,
                DECODE(F.PREPGTO, 'F', 'POS-PGTO', 'PRE-PGTO') CATEGORIA,
                C.NOME NOME_PREST,
                C.CODIGO,
                NVL(C.CPF, C.CNPJ) AS "CPF/CNPJ",
                B.COD_SEG,
                B.NOME NOME_BENEF,
                B.CPF,
                LISTAGG(D.COD_ESPM, '; ') WITHIN GROUP(ORDER BY D.COD_ESPM) "COD_ESPM",
                A.COD_SERV COD_SERV,
                (A.VALOR - A.VALOR_GLOSADO) AS TOTAL,
                DECODE(C.CLINICA, 'F', 'HOSPITAL', 'CLÍNICA') AS LOCAL_,
                G.DT_REALIZACAO DT_ATENDIMENTO
  FROM IM_VTCN1      A,
       IM_SEG        B,
       VW_PRESTADOR  C,
       VW_PREST_ESPM D,
       IM_ESPM       E,
       IM_PLANO      F,
       VW_SERVICOS   G
 WHERE A.COD_SEG = B.COD_SEG(+)
   AND A.COD_ENT = C.CODIGO(+)
   AND C.CODIGO = D.COD(+)
   AND D.COD_ESPM = E.COD_ESPM(+)
   AND B.COD_PLANO = F.COD_PLANO(+)
   AND A.COD_SERV = G.COD_SERV(+)
   AND A.TIPO_ENT = G.TIPO_ENT(+)
   AND A.TIPO_SERV = G.TIPO_SERV(+)
   AND B.COD_SET = &EMPRESA
   AND SUBSTR(A.MES_PGTO, 0, 7) = '&ANO_MES'
 GROUP BY B.COD_PLANO,
          DECODE(F.PREPGTO, 'F', 'POS-PGTO', 'PRE-PGTO'),
          C.NOME,
          C.CODIGO,
          NVL(C.CPF, C.CNPJ),
          B.COD_SEG,
          B.NOME,
          B.CPF,
          A.COD_SERV,
          (A.VALOR - A.VALOR_GLOSADO),
          DECODE(C.CLINICA, 'F', 'HOSPITAL', 'CLÍNICA'),
          G.DT_REALIZACAO
 ORDER BY COD_PLANO, NOME_PREST, B.COD_SEG 
-- A.Carvalho