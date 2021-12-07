# Moving Trend Filters

## Wstęp
https://pl.wikipedia.org/wiki/Jednostka_motoryczna
https://nba.uth.tmc.edu/neuroscience/m/s3/chapter01.html


### Synteza filtru MTF
![Butter1](figury/Synteza1.png) 

### Design Butterworse
```matlab
function [bf, af, Amp, Phase, Wco, iT]=designButter(Tu,rzad,Lxf,fig,kolorB) 
% Tu - okres harmonicznej odcięcia
% rzad rzad filtru,
% Lxf rozmiar tablicy harmonicznych do obliczenia Bodego: xf=[0:Lxf-1],
% Wco indeks amplitudy polowy mocy Amp(Wco)=1/sqrt(2)
% iT ostatni indeks dla Amp(iT).0.09
```

```matlab
designButter(Tud,5,lT,1)
```
![Butter1](figury/Butter1.png) 

## Praca z danymi


![](figury/Fig_P2K2.png) 

> Czy w spektrum powinniśmy widzieć dwa piki?
> 
>![](figury/MTFkody_11.png) 
>
>![](figury/MTFkody_1050Hz.png) 

>![sfd](Fig_P3K33.png) 
Dwojakie
 Działanie mięśnia 

Model mięśnia  czyli odwzorowanie sygnału użytecznego, czyli do jakiej krzywej pasuje 

Sygnał ma 40

kryt jakoścowe
szum na bieg jałowym

dopasowanie trendów 

Eksperymenty czy wzorzec jest trendem,
Batwors poszerza pasmo, szybciej opada
Tud jest umowne