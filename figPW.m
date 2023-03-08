% Program do estymacji nieparametrycznej; 
clear all; 
typKer(1,:)='prostok';
typKer(2,:)='cosinus';
typKer(3,:)='trojkot';
typKer(4,:)='gaussow';
% .............................................
% Obiekt; y(n)=f(V(k,n))+Z(n)
% Wspolczynniki A=[a0 av1 av2 av3 av12 av13 av23 av1_2 av2_2 av3_2]
a0=1; av1=15.5; av2=1.5; av3=1.5; av12=1500; av13=-150; av23=5.5; av1_2=1200; av2_2=1.2; av3_2=200;
A=[a0 av1 av2 av3 av12 av13 av23 av1_2 av2_2 av3_2]; 
Ld=500; 
V=rand(3,Ld); 
Yf=a0+av1*V(1,:)+av2*V(2,:)+av3*V(3,:)+av12*V(1,:).*V(2,:)+av13*V(1,:).*V(3,:)+av23*V(2,:).*V(3,:)+av1_2*V(1,:).^2+ av2_2*V(2,:).^2+av3_2*V(3,:).^2;
sigZ=0.05; % względne odch.stand. zakocenia
DY=max(Yf)-min(Yf); sigmaZ=sigZ*DY; Z=sigmaZ*randn(1,Ld); 
Y=Yf+Z; % Dane empiryczne wyjscia 
load abr_signal2.mat
Y = abr_signal2{1}.data(1:500)';
figure(11), plot(Y)
figPW("fig")
% -----------   Wykresy przekrojowe ---------------------------------------------
figure(1); 
subplot(3,1,1); plot(V(1,:),Y,'k.'); xlabel(sprintf('Dane Y(v_1), Ld=%d',Ld)); axis('tight'); 
subplot(3,1,2); plot(V(2,:),Y,'k.'); xlabel(sprintf('Dane Y(v_2), Ld=%d',Ld)); axis('tight'); 
subplot(3,1,3); plot(V(3,:),Y,'k.'); xlabel(sprintf('Dane Y(v_3), Ld=%d',Ld)); axis('tight');
input(' ?? '); fprintf(1,'\nProsze czekac !!!! ');
% ................. Regresja .....................................
FI(:,1)=ones(Ld,1); 
for(k=2:4) FI(:,k)=V(k-1,:)'; end
FI(:,5)=[V(1,:).*V(2,:)]'; FI(:,6)=[V(1,:).*V(3,:)]'; FI(:,7)=[V(2,:).*V(3,:)]'; 
for(k=8:10) FI(:,k)=[V(k-7,:)'].^2; end
G=inv(FI'*FI); Aob=G*FI'*Y'; 
% ............. Koniec obiektu - obserwacje sa w Y i V ..................................
rKern=0.25; 
% ............. Wybor typu jadra typK --------------------------------------
typK='p'; typK='c'; typK='t'; %typK='g';
r2Kern=rKern^2; wcKern=pi/(rKern/2); wtKern=1/(rKern); tsig=1.5; wgKern=tsig/(r2Kern)/2;
txK=''; if(typK=='g') txK='\sigma_g'; txK=[sprintf('=%.1f*',tsig) txK]; end 
Lobl=200; dv=1/(Lobl-1); v=[0:dv:1]; Lobl=length(v); dKvobl=round(Lobl/10); 
L3=0; 
% ------------ Obliczamy wartosci estymatora dla v1 przy ustalonych v2 i v3 ----------
for(k=1:dKvobl: Lobl)
    L3=L3+1; v3(L3)=v(k); L2=0;
    yfp=a0+av3*v3(L3)+av3_2*v3(L3).^2;
    for(m=1:dKvobl: Lobl) 
        L2=L2+1; v2(L2)=v(m); 
        yfp=yfp+av2*v2(L2)+av23*v2(L2)*v3(L3)+av2_2*v2(L2)^2;
        for(i=1:Lobl)
            Mod(L3).yf(L2,i)=yfp+av1*v(i)+av12*v(i)*v2(L2)+av13*v(i)*v3(L3)+av1_2*v(i)^2;
            lyS=0; Sy=0; 
            for(n=1:Ld) % Dla obliczanego Y^(v(i)) obliczamy f.jšdra dla wszystkich obserwacji n
                dV3=(V(3,n)-v3(L3));  % dlugosc 3.ciej wspolrzednej
                if(abs(dV3)<=rKern) 
                    dV2=(V(2,n)-v2(L2)); % dlugosc 2.giej wspolrzednej
                    if(abs(dV2)<=rKern) r2Dv=dV3^2+dV2^2;  
                        if(r2Dv<r2Kern)
                            r2Dv=r2Dv+(V(1,n)-v(i))^2; % Odleglosc Euclidesa punktu v od V(1:3,n)
                            if(r2Dv<r2Kern) 
                                switch(typK)
                                    case 'c', wy=sqrt(r2Dv)*wcKern; lyS=lyS+wy; Sy=Sy+wy*Y(n); 
                                    case 'p', lyS=lyS+1; Sy=Sy+Y(n);  
                                    case 't', wy=1-sqrt(r2Dv)*wtKern; lyS=lyS+wy; Sy=Sy+wy*Y(n);
                                    case 'g', wy=exp(-r2Dv*wgKern); lyS=lyS+wy; Sy=Sy+wy*Y(n);
                                    otherwise, lyS=lyS+1; Sy=Sy+Y(n);   
                                end
                            end
                        end
                    end
                end
            end
            if(lyS==0) Mod(L3).ym(L2,i)=NaN; else Mod(L3).ym(L2,i)=Sy/lyS; end
            fi(1)=1; fi(2)=v(i); fi(3)=v2(L2);  fi(4)=v3(L3); 
            fi(5)=v(i)*v2(L2); fi(6)=v(i)*v3(L3); fi(7)=v2(L2)*v3(L3);  
            fi(8)=v(i)^2; fi(9)=v2(L2)^2; fi(10)=v3(L3)^2;
            Yob(L3).ym(L2,i)=fi*Aob; 
        end
    end
end
switch(typK) case 'c', nk=2; case 'p', nk=1; case 't', nk=3; case 'g', nk=4; end
nf0=nk; figure(nf0+1)
for(k3=2:L3)
    subplot(3,3,k3-1); wybrv2=[1 2 4 5 7 9]; lw=length(wybrv2); kolV2='kbrmgc'; 
    txt=sprintf('Jadro %s: rKern=%.3f%s, v2=',typKer(nk,:),rKern,txK); for(i=1:lw) txt=[txt sprintf('%.2f %c, ',v2(wybrv2(i)),kolV2(i))]; end
    plot(v,Mod(k3).ym(1,:),'k',v,Mod(k3).ym(2,:),'b',v,Mod(k3).ym(4,:),'r',v,Mod(k3).ym(5,:),'m',v,Mod(k3).ym(7,:),'g',v,Mod(k3).ym(9,:),'c'); 
    hold on; 
    plot(v,Mod(k3).yf(1,:),'k:',v,Mod(k3).yf(2,:),'b:',v,Mod(k3).yf(4,:),'r:',v,Mod(k3).yf(5,:),'m:',v,Mod(k3).yf(7,:),'g:',v,Mod(k3).yf(9,:),'c:'); 
    
    plot(v,Yob(k3).ym(1,:),'k--',v,Yob(k3).ym(2,:),'b--',v,Yob(k3).ym(4,:),'r--',v,Yob(k3).ym(5,:),'m--',v,Yob(k3).ym(7,:),'g--',v,Yob(k3).ym(9,:),'c--'); 
    hold off;
    xlabel(sprintf('v3=%.3f',v3(k3))); ylabel='y(v3,v2,v1)'; 
    axis('tight'); 
end
subplot(3,3,2); title(txt); 
figure(nf0+2)
for(k3=2:L3)
    subplot(3,3,k3-1); 
    mesh(Mod(k3).ym); %mesh([v2,v],Mod(k3).ym); %waterfall(Mod(k3).ym); 
    xlabel(sprintf('v3=%.3f',v3(k3))); ylabel='y(v3,v2,v1)'; 
    axis('tight'); 
end
subplot(3,3,2); title(txt); 
figure(6)
for(k3=2:L3)
    subplot(3,3,k3-1); 
    waterfall(Mod(k3).ym); 
    xlabel(sprintf('v3=%.3f',v3(k3))); ylabel='y(v3,v2,v1)'; 
    axis('tight'); 
end
subplot(3,3,2); title(txt); 

waterfall(Mod(5).ym); mesh(Mod(5).ym)
% put this at the end of your code
if ~isfile('figPSW.m')
 urlwrite ('https://raw.githubusercontent.com/informacja/MTF/main/figPSW.m', 'figPSW.m');
end
figPSW;
