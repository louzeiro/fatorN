%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Funcao para o calculo do N %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  Belem, 07/06/2018 %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Atualizado em 09/06/2018 %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Que Deus me ajude %%%%%%%%%%%%%%%%%%%%%%%%%%


function calculoN
  format bank;                 %% Formatando para 2 casas decimais
  pkg load io                  %% pacote para I/O
  dadosMedidos=xlsread('/home/louzeiro/Documentos/UFPA/tcc/scripts/progs/dados.xlsx'); %% dados medidos
  qtdAmostras= length (dadosMedidos);
 %% 
 figure
plot(dadosMedidos)

 for i=1:qtdAmostras
    d(i,1)=dadosMedidos(i,2);         %% segunda coluna da matriz dadosMedidos
    d0=d(1,1);                   %% distancia inicial
    PR_di(i,1)=dadosMedidos(i,1);     %% Potencia recebida na distancia i,
    PR_d0=PR_di(1,1);            %% Potencia recebida na referencia
  endfor
    
  %% onde P é uma matriz que guarda PR_d0-10Nlog10(d/d0)
  for i=1:qtdAmostras
    colunaN(i)=-10*log10(d(i)/d0);  
    p(i,1)=PR_d0;
    p(i,2)=colunaN(i);      
  endfor
 
  %% A matriz J recebe dois parametros: 
  %% A PR no ponto i menos a potencia recebida em d0  
  %% e a colunaN 
  %%ficando (x - yN), x e y escalar
  a=b=c=0;
  for i=1:qtdAmostras
    J(i,1)=PR_di(i)-p(i,1); 
    J(i,2)=-p(i,2);  
    a=a+(J(i,1)*J(i,1));              %% a=x*x
    b=b+(2*J(i,1)*J(i,2));            %% b=-2*x*y
    c=c+(J(i,2)*J(i,2));              %% c=y*y
  endfor
  n=-b/(2*c);
  
  %%Atualizando o valor da potencia estimada
  for i=1:qtdAmostras
    colunaN(i)=-10*n*log10(d(i)/d0);  
    pEstimada(i,1)=p(i,1)+colunaN(i);      %% o negativo ja está embutido na colunaN
  endfor
  
  %% Calculo do erro quadrado
  Jn=0;
  for i=1:qtdAmostras
    Jn=Jn+(J(i,1)-pEstimada(i,1))^2;  
  endfor
  
  %% Variancia amostral
  varianciaAmostral=Jn/qtdAmostras;
  
  %% Plots
  figure 1
  plot (d, pEstimada, "-;Potencia Estimada;"1;
  hold on;
  plot (d, PR_di, "-r;Potencia Recebida;",1);
  title('Perda de Percurso');
  xlabel('Distancia (m)');
  ylabel('Perda de Percuso (dBm)');
  
  endfunction
