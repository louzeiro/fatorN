function  n = calcN (d,PR_di,d0,PR_d0)
  n=0;
   for i=1:length(d)
      d_v2(i,1)=d(i);
      PR_di_v2(i,1)=PR_di(i);
      colunaN(i)=-10*log10(d(i)/d0);  
      p(i,1)=PR_d0;
      p(i,2)=colunaN(i);
    endfor
 a=b=c=0;
  for i=1:length(PR_di_v2)
    J(i,1)=PR_di_v2(i)-p(i,1) ;
    J(i,2)=-p(i,2);  
    a=a+(J(i,1)*J(i,1));              %% a=x*x
    b=b+(2*J(i,1)*J(i,2));            %% b=-2*x*y
    c=c+(J(i,2)*J(i,2));              %% c=y*y
  endfor
  n=-b/(2*c);
endfunction
