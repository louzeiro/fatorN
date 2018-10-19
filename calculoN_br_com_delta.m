%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Funcao para o calculo do N %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  Belem, 07/06/2018 %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Atualizado em 27/06/2018 %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Que Deus me ajude %%%%%%%%%%%%%%%%%%%%%%%%%%

  clear, close all, clc;
  format bank;                 %% Formatando para 2 casas decimais
  dadosMedidos=[
-97	442
-97	463
-98	479
-98	501
-98	519
-97	537
-97	558
-93	573
-93	588
-93	606
-93	624
-93	644
-94	661
-96	681
-98	701
-99	719
-99	736
-99	754
-101 769
-100 789
-100 809
-99	830
-99	854
-98	879
-98	905
-95	931
-95	954
-94	978
-93	996
-93	1017
-93	1033
-96	1048
-97	1065
-97	1082
-96	1099
-95	1115
-95	1132
-95	1148
-96	1165
-96	1184
-96	1204
-97	1225
-97	1246
-97	1269
-97	1292
-99	1312
-99	1333
-100	1349
-101	1368
-101	1382
-102	1399
-102	1414
-102	1433
-103	1451
-103	1471
-102	1489
-102	1510
-102	1530
-102	1552
-102	1573
-104	1596
-105	1618
-105	1643
-106	1670
-106	1695
-104	1711
-103	1728
-103	1749
-103	1775
-104	1798
-104	1820
-104	1842
-104	1864
-103	1885
-102	1904
];
   qtdAmostras= length (dadosMedidos);
   %% calculo da potencia recebida na distancia de referencia
   Pt=20000;                               %potencia em Watts
   Gt=16;                                  %ganho da Tx
   Gr=0;                                   %ganho da Rx
   f=1800;                                 %frequencia em MHz
   d0=100;                                 %distância inicial em 100m
   Lf=32.5+20*log10(f)+20*log10(d0)-Gt-Gr; %calculo da perda no espaco livre para a distancia d0 
   PtDB=10*log10(Pt);                       
   PR_d0=PtDB-Lf;                          % potencia recebida em d0
   
 %% Organizando os dados
 %d0=1000000;                          %% Iniciando a distancia de referencia com um alto valor 
 for i=1:qtdAmostras
    d(i,1)=dadosMedidos(i,2);    %% Distancia i 
    PR_di(i,1)=dadosMedidos(i,1);     %% Potencia recebida na distancia i,    
  endfor
  
  bp1=1290;
   
  %%% Separando os intervalos dos breaksPoints
  j=k=1;
  for i=1:qtdAmostras
    if (d(i)<=bp1) %breakPoint 1
      d_v1(j,1)=d(i);
      PR_di_v1(j,1)=PR_di(i);
      j=j+1;
    else
      d_v2(k,1)=d(i);
      PR_di_v2(k,1)=PR_di(i);
      k=k+1;
    endif
  endfor
  
  n=calcN(d_v1,PR_di_v1,d0,PR_d0);
  n1=2;%calcN(d_v1,PR_di_v1,d0,PR_d0);
  n2=2.3;%calcN(d_v2,PR_di_v2,bp1,PR_di_v1(1,1));
  
  delta0=1;
  delta1=(bp1/d0)**(n2-n1);
  pEstimada1=pEstimada_v2(n1,d_v1,d0,PR_d0,delta0);
  pEstimada2=pEstimada_v2(n2,d_v2,d0,PR_d0,delta1);
  pEstimadaN=pEstimada_v2(n,d,d0,PR_d0,delta0);
  pEstimadaN1=pEstimada_v2(n1,d,d0,PR_d0,delta0);
  pEstimadaN2=pEstimada_v2(n2,d,d0,PR_d0,delta0);
  
  j=k=1;
  for i=1:qtdAmostras
    if (d(i)<bp1) %breakPoint 1
      pEstimada(i,1)=pEstimada1(j);
      j=j+1;
    else
      pEstimada(i,1)=pEstimada2(k);
      k=k+1;
     endif
  endfor
  
  %adicionando d0 e PR_d0 nos veotres
  
  dist(1)=d0;
  potEstimada(1)=potRecebida(1)=potEstimadaN(1)=potEstimadaN1(1)=potEstimadaN2(1)=PR_d0;
  
   i=2
   for j=1:qtdAmostras
     dist(i)=d(j,1);
     potRecebida(i)=PR_di(j);
     potEstimada(i)=pEstimada(j);
     potEstimadaN(i)=pEstimadaN(j);
     potEstimadaN1(i)=pEstimadaN1(j);
     potEstimadaN2(i)=pEstimadaN2(j);
     i=i+1;
   endfor
 
  figure 1
  plot (dist,potRecebida,"-k;Potencia Medida;");hold on;
  plot (dist,potEstimada,"-r;Potencia estimada com BP;");hold on;
  plot (dist,potEstimadaN2,"-g;Potencia estimada com N2;");hold on;
  plot (dist,potEstimadaN1,"-b;Potencia estimada com N1;");hold on;
  plot (dist,potEstimadaN, "-m;Potencia estimada com N;");hold on;
  grid on;
  
  %plot (d, pEstimada, "-;Perda de percurso;", d, PR_di, "-r;Potencia Medida;");

 % title('Potencia Recebida');
 % xlabel('Separação Tx-Rx (m)');
 % ylabel('Potencia Recebida(dBm)');