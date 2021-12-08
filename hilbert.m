% Lab 11: filtr Hilberta (przesuwnik o -90 stopni, cos() --> sin()
%         sygna³ analityczny: xa(n) = x(n) + j*Hilbert( x(n) ),
%         Acos(alf)+j*Asin(alf)=Aexp(j*alf)
close all; clear all;

fpr = 2000;

Nx = 4000; nx = (0:Nx-1); 
dt = 1/fpr;
t = dt * nx;

if(1)
   f0 = 100;
   AM = 1;
   FM = 50;  
   x = cos( 2*pi*f0*t );
else
   f0 = 100;
   df = 50;
   fm = 1;
   AM = 10*( 1+0.5*sin(2*pi*2*t) );   % 10*[0.5-1.5]
   FM = f0 + df*cos(2*pi*fm*t);
   x = AM .* cos( 2*pi*( f0*t + (df/(2*pi*fm))*sin(2*pi*fm*t) ) );
end
figure; plot( x ); title('x(n)'); pause

if(0)
   xa = hilbert( x );
else
   X = fft(x);
   if(0) % sygna³ analityczny poprzez Hilberta (def. filtra)
      X(1) = 0;
      X(2:Nx/2) = (-j) * X(2:Nx/2);
      X(Nx/2 + 1) = 0;
      X(Nx/2+2:Nx) = (j) * X(Nx/2+2:Nx);
      xH = ifft(X);
      xa = x + j*xH;
   else % sygna³ analityczny bezpoœrednio z definicji widma
      X(1)=0;  
      X(2:Nx/2) = 2*X(2:Nx/2); 
      X(Nx/2+1:Nx) = zeros(1,Nx/2); 
      xa = ifft(X);
   end
end   

df = fpr/Nx;
f = df*(-Nx/2 : Nx/2-1);
figure
subplot(211); plot(f,fftshift(abs(fft(x))));  xlabel('f [Hz]'); title('|X(f)|');
subplot(212); plot(f,fftshift(abs(fft(xa)))); xlabel('f [Hz]'); title('|X(f)|'); pause

AMest = abs( xa );
PMest = unwrap( angle( xa ) );
FMest = (1/(2*pi)) * ( PMest(3:end)-PMest(1:end-2) ) / (2*dt);

figure; plot( nx,AM,'r-',nx,AMest,'b-'), xlabel('n'); title('AM(n)'); grid; pause
figure; plot( nx,AM-AMest,'r-'), xlabel('n'); title('ERR AM(n)'); grid; pause

figure; plot( nx(2:end-1),FM(2:end-1),'r-',nx(2:end-1),FMest,'b-'), xlabel('n'); title('FM(n)'); grid; pause
figure; plot( nx(2:end-1),FM(2:end-1)-FMest,'r-'), xlabel('n'); title('ERR FM(n)'); grid; pause



% ##########################

M = 100; N=2*M+1; n = -M : M;
h = (1-cos(pi*n)) ./ (pi*n); h(M+1) = 0;
figure; stem(n,h); grid; xlabel('n'); title('h(n)'); pause

w = kaiser(N,10)';
figure; stem(n,w); grid; xlabel('n'); title('w(n)'); pause
h = h .* w;
figure; stem(n,h); grid; xlabel('n'); title('h(n)'); pause

f = 0 : 1 : fpr/2;
z = exp(-j*2*pi*f/fpr);
H = polyval( h(end:-1:1), z );
% H=freqz(h,1,f,fpr);

C = exp(j*2*pi*f/fpr*M);
figure
subplot(211); plot(f,20*log10(abs(H))); xlabel('f [Hz]'); title('|H(f)| [dB]'); grid;
subplot(212); plot(f,unwrap(angle(C.*H))); xlabel('f [Hz]'); title('|H(f)| [dB]'); grid; pause

xH = filter( h, 1, x );
xa = x(M+1:end-M) + j*xH(2*M+1:end);

AMest = abs( xa );
PMest = unwrap( angle( xa ) );
FMest = (1/(2*pi)) * ( PMest(3:end)-PMest(1:end-2) ) / (2*dt);

figure; plot( AMest,'b-'), xlabel('n'); title('AM(n)'); grid; pause
figure; plot( FMest,'b-'), xlabel('n'); title('FM(n)'); grid; pause