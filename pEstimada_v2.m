  function p=pEstimada_v2 (n,d,d0,PR_d0,delta)
    p=0;
    for i=1:length(d)
      colunaN(i)=-10*n*log10(d(i)/d0)+10*log10(delta);  
      pEstimada(i,1)=PR_d0+colunaN(i);      %% o negativo ja está embutido na colunaN
    endfor
    p=pEstimada;
  endfunction
  
  
  