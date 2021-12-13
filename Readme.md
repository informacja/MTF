# Moving Trend Filters
[
    ![Praca Dyplomowa](figury/pracDyplom.png) 
](https://docs.google.com/document/d/17OcVbgB8YPnnKoOW4hjLjBLPRd0RgDVMCvWYHTweeac/edit?usp=sharing)

## toDo

- [ ] N liczba osób & liczba gestów
- [ ]

## Wprowadzenie

EMG to powierzchniowe (eng. surface zwane też globalnym) badanie bioelektrycznej aktywności mięśni.
https://docs.google.com/presentation/d/e/2PACX-1vRfEcfP52TywTPmVno2Bt6wgm4HaROeQChxWu-aj8LYmuvUH4RzDNxPejuuWYoAokfBrbt4SRoLLey4/pub?start=false&loop=false&delayms=3000
https://coggle.it/diagram/YbIUH-TqItosZrAC/t/-/47a919cd5319f9533d671f64049f234e41e9f24484d799b7f4371e7f052dabd4

https://pl.wikipedia.org/wiki/Jednostka_motoryczna
https://nba.uth.tmc.edu/neuroscience/m/s3/chapter01.html

### Materiały i metody

Eksperyment przeprowadzono z udziałem 109 osób. Do zapisu wykożystano format WAVE. Pojedynczy plik zawiera 8 kanałów nieskompresowanego sygnału EMG z próbkowanego 2048 razy na sekundę.
Do pomiaru przygotowano instukcję z animacją gestów. https://github.com/informacja/EMG/tree/master/matlab/instrukcja#readme
Proponowany przebieg nagrywania w 7-mio sekundowym oknie 5 sekund aktywności i 1-no sekundowe marginesy bezczynności (ze względu na sekcje początkową i kńcową filtra MTF).
Badany sygnał ma częstotliwość próbkowania 2048 na sekundę.

Konfiguracja aplikacji EMGAnalyzer transferującej sygnał użyteczny.
```cpp
#define DSIZE    4096
#define NCH 8
#define FS 2048
#define QLV_BYTES_PER_WORD 2   // uint16 // Quantisation LeVel, number of bytes per variable. Scale factor
#define DSIZE2   (DSIZE/QLV_BYTES_PER_WORD)

#define VSIZE (DSIZE2/NCH)      // Vector
#define SECONDS 7               // of recording
#define FRCNT NCH*SECONDS       // 8 chanels, 5 seconds

#define FFT_SIZE VSIZE*FRCNT
```

Progowanie
Zadanie
Bodźce
Wydajność behawioralna
ModelowanieSensor selection

Unbiased model
Model SNR

Obniżanie wagi kolejnych dowodów po jawnym wyborze
Dyskusja
Podziękowanie
<!-- 
<img src="https://latex.codecogs.com/gif.latex?P(s | O_t )=\text { Probability of a sensor reading value when sleep onset is observed at a time bin } t " /> -->


### Synteza filtru MTF
>![Butter1](figury/Synteza1.png) 
>Dolna granica filtru to 385 próbek (18 ms)
>Górna granica to        96 próbek  (4 ms)
>następnej równości nie jestem pewien, chodzi o stałą proporcję?
>f/fd = 96/2048

Filtracja dzieli się na 3 segmenty:
- początkowy
- centralny 
```matlab
n0Fzw = 0; npC = N1 + 1; %Lf+1; %=M poczatek segmentu   centralnego
```
- końcowy

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
designButter(Tud, 5, lT, 1)
```
![Butter1](figury/Butter1.png) 

## Praca z danymi

![](figury/Fig_P2K2.png) 

#### 50Hz
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

- [ ] Co to Sprawdzenie filtracji Fzwdc:, fig1 Tu i typ filtru i rząd butter synteza zbiorcza dla tego cf które to wychodzi, filtr nie nie nadaje się do RT, dla cech charakterystycznych
  filtr Rcursywny(zamodelowanie pracy) o długości 400, integrator
- [ ] Jak mierzyć odległość? rozstrzygnąć czy całkować, cewka reaguje na pochodną, żeby odtworzyć pole trzeba całkować
- [ ] Jako propozycja eksprymetu jeden gest(18) palec serdeczny

10  tys.

MTF ustalić położenie (odcięcia) - dojakich cz. warto się zajmować sygnałem(jednoznaczne). Minimum znika po dodaniu po złożeniu z sumarycznej wyznaczam odpowiednik butterworsa.
sTANDARDOWA METOD cutoOF połówkowe wytłumienie mocy;

design butter współ.HalfPower

Następny etap, ortogonalizacja kowariancja przesunięta o 3, ortogonaliza iloczyn skalarny = 0; PrincipleComposeAnalizis Y = W


https://nba.uth.tmc.edu/neuroscience/m/s3/chapter01.html
## Jednostka motoryczna i receptory mięśniowe
Receptory czuciowe dostarczają informacji o środowisku, które są następnie wykorzystywane do wywoływania działań mających na celu zmianę środowiska. Czasami droga od wrażenia do działania jest bezpośrednia, jak w odruchu. Jednak w większości przypadków przetwarzanie poznawcze ma miejsce, aby działania adaptacyjne i właściwe do konkretnej sytuacji.

Wola
Koordynacja sygnałów do wielu grup mięśni.
Niewiele ruchów ogranicza się do aktywacji pojedynczego mięśnia. Na przykład przenoszenie ręki z kieszeni do pozycji przed tobą wymaga skoordynowanej aktywności barku, łokcia i nadgarstka. Wykonywanie tego samego ruchu podczas wyjmowania 2-funtowego ciężarka z kieszeni może skutkować tym samym torem ruchu ręki,
ale będzie wymagał różnych zestawów sił działających na mięśnie, które wykonują ruch. Zadaniem układu ruchu jest określenie niezbędnych sił i koordynacji w każdym stawie, aby wytworzyć ostateczny, płynny ruch ramienia.

Propriocepcja. Aby wykonać pożądany ruch (np. podniesienie ręki, aby zadać pytanie),
układ ruchu musi znać pozycję wyjściową ręki. Podniesienie ręki z pozycji spoczynkowej na biurku, w porównaniu z pozycją spoczynkową na czubku głowy, skutkuje tą samą końcową pozycją ramienia, ale te dwa ruchy wymagają różnych wzorców aktywacji mięśni.
Układ ruchu ma zestaw bodźców czuciowych (zwanych proprioceptorami), które informują go o długości mięśni i przyłożonych do nich siłach; wykorzystuje te informacje do obliczenia pozycji stawu i innych zmiennych niezbędnych do wykonania odpowiedniego ruchu.
Korekty postawy.

Układ ruchu musi stale dostosowywać postawę, aby kompensować zmiany w środku masy ciała, gdy poruszamy kończynami, głową i tułowiem. Bez tych automatycznych regulacji zwykła czynność sięgania po filiżankę spowodowałaby upadek, ponieważ środek masy ciała przesuwa się do miejsca przed osią ciała.

Sensoryczna informacja zwrotna. Oprócz wykorzystania propriocepcji do wyczuwania pozycji ciała przed ruchem, układ ruchowy musi wykorzystywać inne informacje sensoryczne, aby dokładnie wykonać ruch. Porównując pożądaną aktywność z rzeczywistą, sensoryczna informacja zwrotna umożliwia korektę ruchów w miarę ich wykonywania,
a także umożliwia modyfikacje programów motorycznych, dzięki czemu przyszłe ruchy są wykonywane dokładniej.
Kompensacja fizycznych cech ciała i mięśni. Aby wywrzeć określoną siłę na przedmiot, nie wystarczy znać tylko jego właściwości (np. jego masę, rozmiar itp.).

wiele zadań ruchowych wykonywanych jest w sposób automatyczny, niewymagający świadomego przetwarzania. Na przykład wiele korekt postawy, które ciało wykonuje podczas ruchu, jest wykonywanych bez naszej świadomości. Te nieświadome procesy pozwalają obszarom mózgu wyższego rzędu zajmować się szerokimi pragnieniami i celami, a nie niskim
poziomowe implementacje ruchów.

Zdolność adaptacji. Układ ruchu musi dostosowywać się do zmieniających się okoliczności. Na przykład, gdy dziecko rośnie i zmienia się jego ciało, na układ ruchowy nakładane są różne ograniczenia w zakresie wielkości i masy kości i mięśni.


#### Kluczowe koncepce w zrozumieniu kontroli motorycznej:

##### Segregacja funkcjonalna
  Układ ruchu jest podzielony na szereg różnych obszarów, które kontrolują różne aspekty ruchu (strategia „dziel i rządź”). Obszary te znajdują się w całym układzie nerwowym. Jednym z kluczowych pytań w badaniach nad kontrolą motoryczną jest zrozumienie ról funkcjonalnych odgrywanych przez każdy obszar.

##### Organizacja hierarchiczna.
   Różne obszary układu ruchu są zorganizowane w sposób hierarchiczny. Obszary wyższego rzędu mogą zajmować się bardziej globalnymi zadaniami dotyczącymi działania, takimi jak decydowanie, kiedy należy działać, opracowywanie odpowiedniej sekwencji działań i koordynowanie aktywności wielu kończyn.
Nie muszą programować dokładnej siły i prędkości poszczególnych mięśni ani koordynować ruchów ze zmianami postawy; te zadania niskiego poziomu są wykonywane przez niższe poziomy hierarchii.

#### Rdzeń kręgowy: pierwszy poziom hierarchiczny
Rdzeń kręgowy jest pierwszym poziomem hierarchii motorycznej. Jest to miejsce, w którym znajdują się neurony ruchowe. Jest to również miejsce wielu interneuronów i złożonych obwodów neuronowych, które wykonują przetwarzanie „nakrętek i śrub” sterowania silnikiem. Obwody te realizują niskie
komendy poziomu, które generują odpowiednie siły na poszczególne mięśnie i grupy mięśni, aby umożliwić ruchy adaptacyjne. Rdzeń kręgowy zawiera również złożone obwody służące do takich rytmicznych zachowań, jak chodzenie. Ponieważ ten niski poziom hierarchii dba o te podstawowe funkcje,
wyższe poziomy (takie jak kora ruchowa) mogą przetwarzać informacje związane z planowaniem ruchów, konstruowaniem adaptacyjnych sekwencji ruchów i koordynacją ruchów całego ciała, bez konieczności kodowania dokładnych szczegółów każdego skurczu mięśnia.

#### Neurony ruchowe
Neurony ruchowe alfa (zwane również dolnymi neuronami ruchowymi) unerwiają mięsień szkieletowy i powodują skurcze mięśni, które generują ruch. Neurony ruchowe uwalniają neuroprzekaźnik acetylocholinę w synapsie zwanej złączem nerwowo-mięśniowym. Kiedy acetylocholina wiąże się z receptorami acetylocholiny na włóknie mięśniowym,
potencjał czynnościowy jest propagowany wzdłuż włókna mięśniowego w obu kierunkach (patrz rozdział 4 sekcji I do przeglądu). Potencjał czynnościowy wyzwala skurcz mięśnia. Jeżeli końce mięśnia są nieruchome, utrzymując mięsień na tej samej długości, to skurcz skutkuje zwiększeniem siły na podporach (skurcz izometryczny).
Jeśli mięsień skraca się bez oporu, skurcz powoduje stałą siłę (skurcz izotoniczny). Neurony ruchowe, które kontrolują ruchy kończyn i ciała, znajdują się w przednim rogu rdzenia kręgowego, a neurony ruchowe, które kontrolują ruchy głowy i twarzy, znajdują się w jądrach ruchowych pnia mózgu.

Figure 1.3

Neurony ruchowe to nie tylko kanały poleceń motorycznych generowanych z wyższych poziomów hierarchii. Same są komponentami złożonych obwodów, które wykonują wyrafinowane przetwarzanie informacji. Jak pokazano na rycinie 1.3, neurony ruchowe mają silnie rozgałęzione, skomplikowane drzewa dendrytyczne,
umożliwiając im integrowanie wejść z dużej liczby innych neuronów i obliczanie odpowiednich wyjść.

Do opisu anatomicznych relacji między neuronami ruchowymi a mięśniami używane są dwa terminy: pula neuronów ruchowych i jednostka ruchowa.


###### Neurony ruchowe
 są skupione w kolumnowych jądrach rdzeniowych zwanych pulami neuronów ruchowych (lub jądrami ruchowymi).
Wszystkie neurony ruchowe w puli neuronów ruchowych unerwiają pojedynczy mięsień (ryc. 1.4), a wszystkie neurony ruchowe, które unerwiają określony mięsień, znajdują się w tej samej puli neuronów ruchowych. Tak więc istnieje relacja jeden do jednego między mięśniem a pulą neuronów ruchowych.

###### Każde pojedyncze włókno mięśniowe
 w mięśniu jest unerwione przez jedno i __tylko jeden__,
neuron ruchowy (upewnij się, że rozumiesz różnicę między mięśniem a włóknem mięśniowym). Pojedynczy neuron ruchowy może jednak unerwiać __wiele włókien mięśniowych__. Kombinacja pojedynczego neuronu ruchowego i wszystkich unerwianych przez niego włókien mięśniowych nazywana jest jednostką motoryczną.
Liczba włókien unerwionych przez jednostkę motoryczną nazywana jest *współczynnikiem unerwienia*.

Jeśli mięsień jest potrzebny do precyzyjnej kontroli lub delikatnych ruchów (np. ruch palców lub dłoni), jego jednostki motoryczne będą miały małe współczynniki unerwienia. Oznacza to, że każdy neuron ruchowy unerwia niewielką liczbę włókien mięśniowych (10-100), umożliwiając wiele niuansów ruchu całego mięśnia.
Jeśli mięsień jest potrzebny tylko do wykonywania ruchów niepełnych (np. mięsień udowy), jego jednostki motoryczne będą miały wysoki współczynnik unerwienia (tj. każdy neuron ruchowy unerwia 1000 lub więcej włókien mięśniowych), ponieważ nie ma potrzeby stosowania poszczególnych mięśni włókna ulegają wysoce skoordynowanym, zróżnicowanym skurczom w celu wytworzenia delikatnego ruchu.

#### Kontrola siły mięśni
Neuron ruchowy kontroluje ilość siły wywieranej przez włókna mięśniowe. Istnieją dwie zasady, które rządzą związkiem między aktywnością neuronów ruchowych a siłą mięśni: kod szybkości ( tempo odpalania) i zasada (rozmiaru) wielkości.

##### 1. Tempo odpalania
Neurony ruchowe wykorzystują regulację tempa, aby zasygnalizować ilość siły, jaką ma wywierać mięsień. Wzrost szybkości potencjałów czynnościowych wystrzeliwanych przez neuron ruchowy powoduje wzrost ilości siły generowanej przez jednostkę motoryczną. Ten kod jest przedstawiony na rysunku 1.5.
mięsień lekko drga, a następnie rozluźnia się z powrotem do stanu spoczynku. Jeśli neuron ruchowy wystrzeli po powrocie mięśnia do stanu wyjściowego, wtedy wielkość następnego skurczu mięśnia będzie taka sama jak pierwszego. Jeśli jednak tempo odpalania neuronu ruchowego wzrasta, tak, że drugi potencjał czynnościowy pojawia się zanim mięsień zrelaksuje się z powrotem do stanu wyjściowego, wtedy drugi potencjał czynnościowy wytwarza większą ilość siły niż pierwszy (tj. sumuje się siła skurczu mięśnia) Wraz ze wzrostem "szybkostrzelności" całka staje się silniejsza, aż do pewnego limitu.
Kiedy kolejne potencjały czynnościowe nie powodują już sumowania się skurczu mięśnia (ponieważ mięsień jest w swoim maksymalnym stanie skurczu), mięsień znajduje się w stanie zwanym *tetanus*

##### 2. Zasada rozmiaru
Gdy do neuronów ruchowych wysyłany jest sygnał, aby wykonać ruch, neurony ruchowe nie są rekrutowane w tym samym czasie lub losowo. Zasada wielkości neuronu ruchowego stwierdza, że ​​wraz ze wzrostem siły sygnału wejściowego do neuronów ruchowych,
mniejsze neurony ruchowe są rekrutowane i potencjały czynnościowe ognia przed rekrutacją większych neuronów ruchowych. Dlaczego dochodzi do tej uporządkowanej rekrutacji? Przypomnij sobie zależność między napięciem, prądem i rezystancją (prawo Ohma): V = IR. Ponieważ mniejsze neurony ruchowe mają mniejszą powierzchnię błony, mają mniej kanałów jonowych, a tym samym większą rezystancję wejściową. Większe neurony ruchowe mają większą powierzchnię błony i odpowiednio więcej kanałów jonowych; dlatego mają mniejszą rezystancję wejściową. Ze względu na prawo Ohma niewielka ilość prądu synaptycznego wystarczy, aby potencjał błonowy małego neuronu ruchowego osiągnął próg odpalenia,
podczas gdy duży neuron ruchowy pozostaje poniżej progu. Wraz ze wzrostem natężenia prądu wzrasta również potencjał błonowy większego neuronu ruchowego, aż do osiągnięcia progu odpalania.

Ponieważ jednostki motoryczne są rekrutowane w uporządkowany sposób, słabe impulsy do neuronów motorycznych powodują, że tylko kilka jednostek motorycznych jest aktywnych, co skutkuje niewielką siłą wywieraną przez mięsień (Play 1). Przy silniejszych wejściach rekrutowanych będzie więcej neuronów ruchowych,
co skutkuje większą siłą przyłożoną do mięśnia (Play 2 i Play 3). Ponadto różne typy włókien mięśniowych są unerwione przez małe i większe neurony ruchowe. Małe neurony ruchowe unerwiają wolnokurczliwe włókna; Średniej wielkości neurony ruchowe unerwiają szybkokurczliwe, odporne na zmęczenie włókna; a duże neurony ruchowe unerwiają szybkokurczliwe, męczące włókna mięśniowe.

Włókna wolnokurczliwe wytwarzają mniejszą siłę niż włókna szybkokurczliwe, ale są w stanie utrzymać ten poziom siły przez długi czas. Włókna te służą do utrzymywania postawy i wykonywania innych ruchów o niewielkiej sile.


1.11 Neurony ruchowe gamma

Chociaż włókna wewnątrzzrostowe nie przyczyniają się znacząco do skurczu mięśni, mają na końcach elementy kurczliwe unerwione przez neurony ruchowe.

Neurony ruchowe dzielą się na dwie grupy. Neurony ruchowe alfa unerwiają włókna pozazębowe (szkieletowe), silnie kurczące się włókna, które dostarczają moc mięśniom. Neurony ruchowe gamma unerwiają włókna śródrdzeniowe, które kurczą się tylko nieznacznie. Funkcją skurczu śródzębowego włókien nie jest dostarczanie siły mięśniowi; raczej, Aktywacja gamma włókna śródrdzeniowego jest niezbędna do utrzymania naprężenia wrzeciona mięśniowego, a tym samym wrażliwości na rozciąganie, w szerokim zakresie długości mięśni. Koncepcję tę ilustruje rysunek 1.10. Jeśli mięsień spoczynkowy jest rozciągnięty, wrzeciono mięśniowe rozciąga się równolegle, wysyłając sygnały przez pierwotne i wtórne aferenty.
Jednak następujący po tym skurcz mięśnia usuwa naciąganie wrzeciona i staje się ono luźne, powodując, że aferenty wrzeciona przestają działać. Gdyby mięsień miał być ponownie rozciągnięty, wrzeciono mięśniowe nie byłoby w stanie zasygnalizować tego rozciągnięcia. 

Zatem,
wrzeciono staje się tymczasowo niewrażliwe na rozciąganie po skurczu mięśnia. Aktywacja gamma neuronów ruchowych zapobiega tej tymczasowej niewrażliwości, powodując słaby skurcz włókien śródzębowych, równolegle ze skurczem mięśnia.
Skurcz ten utrzymuje wrzeciono cały czas napięte i utrzymuje jego wrażliwość na zmiany długości mięśnia. Tak więc, gdy centralny system nerwowy wydaje polecenie skurczu mięśnia, nie tylko wysyła odpowiednie sygnały do ​​neuronów ruchowych alfa, ale także instruuje neurony ruchowe gamma, aby odpowiednio skurczyły włókna śródzębowe;
ten skoordynowany proces jest określany jako koaktywacja alfa-gamma.



http://www.dydaktyka.ib.pwr.wroc.pl/materialy/MDP002002L%20Fizjologia/ABC%20EMG.pdf