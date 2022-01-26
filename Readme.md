# Moving Trend Filters
[
    ![Praca Dyplomowa](figury/pracDyplom.png) 
](https://docs.google.com/document/d/17OcVbgB8YPnnKoOW4hjLjBLPRd0RgDVMCvWYHTweeac/edit?usp=sharing)

## Wprowadzenie

EMG to powierzchniowe (eng. surface zwane też globalnym) badanie bioelektrycznej aktywności mięśni.
[
  ![MM](figury/mapMTF.png)
](https://coggle.it/diagram/YbIUH-TqItosZrAC/t/-/47a919cd5319f9533d671f64049f234e41e9f24484d799b7f4371e7f052dabd4)

Spis treści
Wstęp	5
1 Omówienie mechanizmów biologicznego sterowania pracą mięśni	8
1.1 Teoria biologicznego sterowania ruchem	11
1.1.1 Jednostka motoryczna i receptory mięśniowe	11
1.1.1.1 Wola — decyzje psychologiczne, a sygnały bioniczne	11
1.1.1.2 Propriocepcja	12
1.1.1.3 Układ ruchu	12
1.1.1.4 Sensoryczna informacja zwrotna	12
1.1.1.5 Zdolność adaptacji	12
1.1.2 Kluczowe koncepcje w zrozumieniu kontroli motorycznej	13
1.1.2.1 Segregacja funkcjonalna	13
1.1.2.2 Organizacja hierarchiczna	13
1.1.3 Rdzeń kręgowy: pierwszy poziom hierarchiczny	13
1.1.4 Neurony ruchowe	13
1.1.4.1 Pula neuronów ruchowych	14
1.1.4.2 Pojedyncze włókno mięśniowe	15
1.1.5 Kontrola siły mięśni	15
1.1.5.1 Tempo odpalania	16
1.1.5.2 Zasada rozmiaru	16
1.1.6 Neurony ruchowe gamma	17
2 Wykorzystane techniki pomiarowe	19
2.1 Zakres badań	19
2.1.1 Sprzęt pomiarowy	19
2.1.1.1 Elektrody	19
2.1.2 Analiza merytoryczna źródeł zakłóceń i szumów pomiarowych	21
2.1.3 Oprogramowanie systemu pomiarowego	23
2.1.3.1 Konfiguracja	23
2.1.4 Czynności przed zbieraniem sygnałów	23
2.1.4.1 Przygotowanie skóry	24
2.1.4.2 Ułożenie elektrod	24
3 Wykorzystane metody przetwarzania sygnałów	25
3.1 Historyczne początki	25
3.2 Konstrukcja sygnałów diagnostycznych w dziedzinie czasu	25
3.3 Analiza widmowa sygnałów diagnostycznych	28
3.4 Synteza filtrów cyfrowych	29
3.4.1 Zasady filtracji cyfrowej	29
3.4.2 Synteza filtrów FIR typu MTF	31
3.4.3 Projektowanie filtrów Butterwortha	34
4 Badania właściwości sygnałów diagnostycznych EMG	36
4.1 Cel badań i przeprowadzone eksperymenty	36
4.2 Omówienie reprezentatywnych wyników badań	38
4.2.1 Badania zgięcia palców	38
5 Zakończenie	46
6 Bibliografia	47
7 Aneks - Sygnał ⚡ Obiekt 📽️ Model 💭	49
7.1 Podstawy - metajęzyk abstrakcji, pośredniczący w osiąganiu celu	49
7.2 Dziedzina określa ograniczenie warstwy eksperckiej znaczenia słów	49
7.3 Czym różni się obiekt od modelu?	50
7.4 Przypadki użycia (Use Case from UML)	51
7.5 Budowanie modelu	51
7.6 Rozwój Liniowej Dynamiki	52

## 0.1 Wstęp

Oddziaływanie na układ mięśniowy ruchu człowieka, odbywa się zgodnie z zasadą; feed-forward, feed-back. Oddziaływania feed-forward (programowe), dotyczą pobudzania dla określonego celu, a  feedback spełniają rolę korekcyjną. Oddziaływania te mają naturę elektryczną i polegają na generowaniu tzw. sygnałów elektromiograficznych (skrót EMG), przesyłanych z rdzenia lub kory mózgowej do właściwych włókien mięśni odpowiednimi połączeniami aksonalnymi z prędkością  ok. 70-120 m/s. [Fiz14] Sygnały te są mierzalne przy pomocy specjalnych sensorów na powierzchni skóry (tzw. badanie powierzchniowe zwane też globalnym bioelektrycznej aktywności mięśni).
 Znaczna część oddziaływań odbywa się poza świadomością człowieka (pobudzanie mięśni serca, szkieletowe itp,) Świadome decyzje określające cel pobudzania mięśni, można nazwać wolą. Dotyczą one przede wszystkim mięśni kończyn dla wykonania określonych ruchów motorycznych ciała. Decyzje te są oczywiście korygowane oddziaływaniami typu feed-back. Badania medyczne wykazały [ABC07], że sygnały EMG generowane jako ekspresja woli, są wysyłane do kończyn także wówczas, gdy skutek amputacji, nie istnieją mięśnie, do których są adresowane. Ten fakt można wykorzystać do budowy protez, np. dłoni czy stopy, sterowanych wolą człowieka, o ile dostępne są mięśnie części amputowanej,
z której da się odczytać sygnał EMG. To zagadnienie jest przedmiotem niniejszej pracy.
Wg. artykułu [HipFiz11], człowiek traci możliwość hiperplazji (rozrostu, zwiększenia ilości włókien) wkrótce po urodzeniu. Każdy człowiek rodzi się z pewną ilością włókien mięśniowych, która jest statystycznie niezmienna, to wytrenowanie jest warunkiem koniecznym podnoszenia ciężaru.
Autor zetknął się z problemem 4 lata temu, na początku swoich studiów, gdy poznał kolegę, który w wyniku wypadku motocyklowego ma uszkodzony nerw barku i dłoni, przez co utracił precyzję wykonywanych ruchów dłoni. Ze względu na zainteresowanie tym tematem, w roku 2020/21 autor zaangażował się w pracę zespołu interdyscyplinarnego działającego w PWSZ Tarnów, współrealizującego projekt badawczy rektora PWSZ pt. „Design and verification of bionic hand control using EMG signal”. Zespół wykonał fizyczny model dłoni metodą druku 3D, a prace badawcze idą w kierunku wypracowania modelu sieci neuronowej, służącej do identyfikacji sygnałów sterujących układem wykonawczym silników sterujących protezą, które mają odwzorowywać wolę użytkownika tej protezy. W niniejszej pracy, podjęto próbę czy sygnały takie można podać identyfikacji metodami filtracji pasmowej, autor inspirowany przez opiekuna, stawia hipotezę, że sygnały takie można zidentyfikować klasycznymi metodami analizy częstotliwościowej i filtracji cyfrowej.
Praca ma charakter eksperymentalny interdyscyplinarny, ukierunkowany na syntezę informacji pozyskanej z pracy mięśni do kontroli sygnału wyjściowego w zastosowaniu przykładowym do kontroli robotycznej dłoni. Uzyskany zapis audio na podstawie sygnałów mięśniowych tzw. “mowy mięśni”, może posłużyć do wspomagania rehabilitacji
i w zastosowaniu protetycznym dla osób, które są po uszkodzeniu kończyny górnej. Jest wiele firm w Małopolsce (np. GlazeProsthetics, Össur) produkujących protezy. W związku z tym prace zmierzające do doskonalenia takich protez mogą mieć bezpośrednie zastosowanie.

Rozdział pierwszy omawia mechanizmy sterowania ruchem mięśni od strony biologiczno-medycznej.
Rozdział drugi zawiera opis zastosowanych metod przetwarzania EMG i autorskie oprogramowanie wykorzystane do tego celu.
W Rozdziale trzecim przedstawiono wykorzystane w tej pracy metody przetwarzania sygnałów w celu identyfikacji sygnału, który może być wykorzystany bezpośrednio do sterowania napędami protezy.
Rozdział czwarty przedstawia wyniki badań empirycznych zmierzających do wypracowania skoordynowanych akcji poszczególnych palców protezy
W zakończeniu podsumowano efekty badań i zarysowano możliwości badań

Dla potrzeb pracy autor opracował oprogramowanie w języku MATLAB do odczytywania sygnałów EMG, ich wstępnego przetwarzania i ich rejestracji (Finger EMG, WaveApp) oraz porównywania zmierzonych sygnałów (pliki wczytajEMG.m, plotTrendStaticAxis.m, figPW.m), a we współpracy z opiekunem - plik MTFbion.m, wykorzystany do analizy częstotliwościowej i filtracji w czasie rzeczywistym. 

Pracę uzupełnia aneks prezentujący przemyślenia autora dotyczące sposobów syntetycznej wizualizacji metod analizy systemów dynamicznych.

Modułowe podejście przyjęte w grancie zaprezentowano na Rys. 1, autor odpowiada za część centralną (w zielonej elipsie).
Rys. 1. Modułowa struktura projektu “Bioniczna Dłoń” realizowanego przez zespół


# 1 Omówienie mechanizmów biologicznego sterowania pracą mięśni	
Znaczenie protetyki medycznej dla osób po wypadku np. w transporcie publicznym, które mogą mieć wszczepiony implant, jest nie do przecenienia. Jeśli sprawne pozostają odpowiednie neurony, to sygnał woli, wychodzący z kory mózgowej, jest przesyłany w miejsce, gdzie włókna mięśniowe uległy uszkodzeniu. Sygnał taki może być odczytany przez oczujnikowany implant i po odpowiednim przetworzeniu skierowany do układów wykonawczych sterowania protezą. 
Badanie elektromiograficzne wskazuje, czy mięsień jest prawidłowy, czy zmieniony patologicznie, co pozwala odróżnić, czy uszkodzenie jest pierwotnie mięśniowe neurogenne, czy ma charakter uogólniony, czy lokalny, ostry czy przewlekły.

Rys. 1.1. Schemat ilustrujący rejestrację igłową elektrodą koncentryczną potencjału jednostki ruchowej (A) jako sumy potencjałów pojedynczych włókien. B. Potencjał propagowany jest wzdłuż włókna z prędkością proporcjonalną do średnicy włókna.

Własności elektryczne i magnetyczne organizmów żywych  zależą od własności, elektrycznych komórek wraz z ich strukturalnymi częściami (organellami) i od własności substancji międzykomórkowych Główna substancja wypełniająca komórki, cytoplazma, jest koloidem złożony z różnorodnych cząsteczek białkowych, wykazuje ona własności elektrolitu, a jej przewodność zależy od koncentracji poszczególnych rodzajów jonów i ich ruchliwości. Szczególnie istotne są małe jony H+, Na+, Cl- ze względu na ich dużą ruchliwość.


Rys. 1.2. Pompa sodowo-potasowa [ABC 07]

Na koniec należy wspomnieć, że pompa sodowo-potasowa działa niesymetrycznie, ponieważ przesuwa 3 jony sodu z wnętrza komórki na zewnątrz na każde 2 jony potasu przesuwane w kierunku przeciwnym. Efektem działania pompy sodowo-potasowej jest reakcja na bodźce.

Rys. 1.3.Z lewej ideowe reagowanie na bodziec, prawy rysunek ukazuje udział pierwiastków w działaniu pompy

Po przekroczeniu pewnego progu przez napływające do wnętrza komórki jony Na+ na błonie pojawia się szybko zmieniający swoje wartości od - 80 mV do + 30 mV potencjał czynnościowy (Rys. 1.3). Jest to jednobiegunowe wyładowanie elektryczne, które jest natychmiastowo równoważone w fazie repolaryzacji, po której następuje faza hiperpolaryzacji błony.
Pobudzenie to powoduje uwalnianie jonów wapnia w przestrzeni wewnątrzkomórkowej. Połączone procesy chemiczne (sprzężenie elektromechaniczne)
w konsekwencji powodują skrócenie elementów kurczliwych w komórce mięśniowej. Sygnał EMG powstaje dzięki potencjałom czynnościowym włókien mięśniowych, pojawiających się wskutek opisanych powyżej procesów depolaryzacji i repolaryzacji. Szerokość strefy depolaryzacji w literaturze opisywana jest jako 1-3mm² [ABC07]. Po początkowym pobudzeniu tej strefy, przesuwa się ona wzdłuż włókna mięśniowego z szybkością około 2-6 m/s przechodząc pod elektrodą rejestrującą. (Rys. 8) 

  

Rys. 1.4. Zależność czasowa widmowej modyfikacji mięśnia [Del93]

Rys 1.5. Wskaźnik zaangażowania mięśnia [Del93]

Elektronerurologia daje  możliwość oceny funkcji badanego nerwu, charakteru stwierdzanych zmian (demielinizacyjne, aksonalne), lokalizacji uszkodzenia  i dynamiki toczącego się procesu. Obie metody stosowane często u tego samego chorego  pozwalają  na ocenę  układu nerwowo-mięśniowego, określenie  rodzaju uszkodzenia i analizę mechanizmów  zachodzących procesów.
Cel badań to klasyfikacja przebiegów napięć czynnościowych odpowiadających różnym akcjom mięśni, dla potrzeb budowy inteligentnej protezy dłoni. W szczególności wykonane zostały następujące eksperymenty:
Pomiar spoczynkowy
Ruch pojedynczych palców
Zaciśnięcie pięści
## 1.1 Teoria biologicznego sterowania ruchem [Kni20] [Wiki]
### 1.1.1 Jednostka motoryczna i receptory mięśniowe
Receptory czuciowe dostarczają informacji o środowisku, które są następnie wykorzystywane do wywoływania działań mających na celu zmianę środowiska. Czasami droga od wrażenia do działania jest bezpośrednia, jak w odruchu. Jednak w większości przypadków przetwarzania poznawczego mają miejsce działania adaptacyjne odpowiednio do konkretnej sytuacji.

Rys. 1.6. Schemat przepływu informacji, od środowiska przez czucie (refleks) i adaptację poznawczą do działania
#### 1.1.1.1 Wola — decyzje psychologiczne, a sygnały bioniczne
Niewiele ruchów ogranicza się do aktywacji pojedynczego mięśnia, zatem konieczna jest koordynacja sygnałów do wielu grup mięśni. Na przykład przenoszenie ręki z kieszeni do pozycji przed sobą wymaga skoordynowanej aktywności barku, łokcia i nadgarstka. Wykonywanie tego samego ruchu podczas wyjmowania półkilogramowego ciężarka z kieszeni może skutkować tym samym torem ruchu ręki, ale będzie wymagał różnych zestawów sił działających na mięśnie, które wykonują ruch. Zadaniem układu ruchu jest określenie niezbędnych sił i koordynacji w każdym stawie, aby wytworzyć ostateczny, płynny ruch ramienia.
#### 1.1.1.2 Propriocepcja 
Aby wykonać pożądany ruch (np. podniesienie ręki, aby zadać pytanie), układ ruchu musi znać pozycję wyjściową ręki. Podniesienie ręki z pozycji spoczynkowej na biurku, w porównaniu z pozycją spoczynkową na czubku głowy, skutkuje tą samą końcową pozycją ramienia, ale te dwa ruchy wymagają różnych wzorców aktywacji mięśni. Układ ruchu ma zestaw bodźców czuciowych (zwanych proprioceptorami [WikiPro]), które informują go o długości mięśni i przyłożonych do nich siłach. Układ wykorzystuje te informacje do wypracowania oddziaływania na  pozycję stawu i inne zmienne niezbędne do wykonania odpowiedniego ruchu, korekty postawy.
#### 1.1.1.3 Układ ruchu
 Układ ruchu musi stale dostosowywać postawę, aby kompensować zmiany w środku masy ciała, gdy poruszamy kończynami, głową i tułowiem. Bez tych automatycznych regulacji zwykła czynność sięgania po filiżankę spowodowałaby upadek, ponieważ środek masy ciała przesuwa się do miejsca przed osią ciała.
#### 1.1.1.4 Sensoryczna informacja zwrotna
 Oprócz wykorzystania propriocepcji (sterowania otwartego - feed forward) do wyczuwania pozycji ciała przed ruchem, układ ruchowy musi wykorzystywać inne informacje sensoryczne, aby dokładnie wykonać ruch. Porównując pożądaną aktywność z rzeczywistą, sensoryczna informacja zwrotna umożliwia korektę ruchów w miarę ich wykonywania, a także umożliwia modyfikację programów motorycznych, dzięki czemu przyszłe ruchy są wykonywane dokładniej. Kompensacja fizycznych cech ciała i mięśni. Aby wywrzeć określoną siłę na przedmiot, nie wystarczy znać tylko jego właściwości (np. jego masę, rozmiar itp.).
Wiele zadań ruchowych wykonywanych jest w sposób automatyczny, niewymagający świadomego przetwarzania. Na przykład wiele korekt postawy, które ciało wykonuje podczas ruchu, jest wykonywanych bez naszej świadomości. Te nieświadome procesy pozwalają obszarom mózgu wyższego rzędu zajmować się szerokimi pragnieniami i celami, a nie niskopoziomowym implementowaniem ruchów.
#### 1.1.1.5 Zdolność adaptacji
 Układ ruchu musi dostosowywać się do zmieniających się okoliczności. Na przykład, gdy dziecko rośnie i zmienia się jego ciało, na układ ruchowy nakładane są różne ograniczenia w zakresie wielkości i masy kości i mięśni.
### 1.1.2 Kluczowe koncepcje w zrozumieniu kontroli motorycznej
#### 1.1.2.1 Segregacja funkcjonalna
Układ ruchu jest podzielony na szereg różnych obszarów, które kontrolują różne aspekty ruchu (strategia „dziel i rządź”). Obszary te znajdują się w całym układzie nerwowym. Jednym z kluczowych pytań w badaniach nad kontrolą motoryczną jest zrozumienie ról funkcjonalnych odgrywanych przez każdy obszar.
#### 1.1.2.2 Organizacja hierarchiczna
Różne obszary układu ruchu są zorganizowane w sposób hierarchiczny. Obszary wyższego rzędu mogą zajmować się bardziej globalnymi zadaniami dotyczącymi działania, takimi jak decydowanie, kiedy należy działać, opracowywanie odpowiedniej sekwencji działań i koordynowanie aktywności wielu kończyn. Nie muszą programować dokładnej siły i prędkości poszczególnych mięśni ani koordynować ruchów ze zmianami postawy; te zadania niskiego poziomu są wykonywane przez niższe poziomy hierarchii.
### 1.1.3 Rdzeń kręgowy: pierwszy poziom hierarchiczny
Rdzeń kręgowy jest pierwszym poziomem hierarchii motorycznej. Jest to miejsce, w którym znajdują się neurony ruchowe. Jest to również miejsce wielu interneuronów i złożonych obwodów neuronowych, które wykonują przetwarzanie „abecadła” sterowania ruchem. Obwody te realizują komendy niskiego poziomu, które generują odpowiednie siły na poszczególne mięśnie i grupy mięśni, aby umożliwić ruchy adaptacyjne. Rdzeń kręgowy zawiera również złożone obwody służące do takich rytmicznych zachowań, jak chodzenie. Ponieważ ten niski poziom hierarchii dba o te podstawowe funkcje, wyższe poziomy (takie jak kora ruchowa) mogą przetwarzać informacje związane z planowaniem ruchów, konstruowaniem adaptacyjnych sekwencji ruchów i koordynacją ruchów całego ciała, bez konieczności kodowania dokładnych szczegółów każdego skurczu mięśnia.
### 1.1.4 Neurony ruchowe
Neurony ruchowe alfa (zwane również dolnymi neuronami ruchowymi) unerwiają mięsień szkieletowy i powodują skurcze mięśni, które generują ruch. Neurony ruchowe uwalniają neuroprzekaźnik acetylocholinę w synapsie zwanej złączem nerwowo-mięśniowym. Kiedy acetylocholina wiąże się z receptorami acetylocholiny na włóknie mięśniowym, potencjał czynnościowy jest propagowany wzdłuż włókna mięśniowego w obu kierunkach. Potencjał czynnościowy wyzwala skurcz mięśnia. Jeżeli końce mięśnia są nieruchome, utrzymując mięsień na tej samej długości, to skurcz skutkuje zwiększeniem siły na podporach (skurcz izometryczny). Jeśli mięsień skraca się bez oporu, skurcz powoduje stałą siłę (skurcz izotoniczny). Neurony ruchowe, które kontrolują ruchy kończyn i ciała, znajdują się w przednim rogu rdzenia kręgowego, a neurony ruchowe, które kontrolują ruchy głowy i twarzy, znajdują się w jądrach ruchowych pnia mózgu.

Rys 1.7. Rdzeń kręgowy z neuronem ruchowym w rogu przednim [Kni20F1.3]
Neurony ruchowe to nie tylko kanały poleceń motorycznych generowanych
z wyższych poziomów hierarchii. Same są komponentami złożonych obwodów, które wykonują wyrafinowane przetwarzanie informacji. Jak pokazano na Rys. 1.7, neurony ruchowe mają silnie rozgałęzione, skomplikowane drzewa dendrytyczne, umożliwiając im integrowanie wejść z dużej liczby innych neuronów i obliczanie odpowiednich wyjść.
Do opisu anatomicznych relacji między neuronami ruchowymi a mięśniami używane są dwa terminy: pula neuronów ruchowych i jednostka ruchowa.
#### 1.1.4.1 Pula neuronów ruchowych
Neurony ruchowe są skupione w kolumnowych jądrach rdzeniowych zwanych pulami neuronów ruchowych (lub jądrami ruchowymi). Wszystkie neurony ruchowe w puli neuronów ruchowych unerwiają pojedynczy mięsień (Rys. 1.8), a wszystkie neurony ruchowe, które unerwiają określony mięsień, znajdują się w tej samej puli neuronów ruchowych. Tak więc istnieje relacja jeden do jednego między mięśniem a pulą neuronów ruchowych.
Rys. 1.8. Jednostka ruchowa i pula neuronów ruchowych. [Kni20F1.4]
#### 1.1.4.2 Pojedyncze włókno mięśniowe
Każde pojedyncze włókno mięśniowe w mięśniu jest unerwione przez jeden i tylko jeden neuron ruchowy (należy mieć świadomośc istotnej różnicy mięśniem a włóknem mięśniowym). Pojedynczy neuron ruchowy może jednak unerwiać wiele włókien mięśniowych. Kombinacja pojedynczego neuronu ruchowego i wszystkich unerwianych przez niego włókien mięśniowych nazywana jest jednostką motoryczną. Liczba włókien unerwionych przez jednostkę motoryczną nazywana jest współczynnikiem unerwienia.
Jeśli mięsień jest potrzebny do precyzyjnej kontroli lub delikatnych ruchów (np. ruch palców lub dłoni), jego jednostki motoryczne będą miały małe współczynniki unerwienia. Oznacza to, że każdy neuron ruchowy unerwia niewielką liczbę włókien mięśniowych (10-100), umożliwiając wiele niuansów ruchu całego mięśnia. Jeśli mięsień jest potrzebny tylko do wykonywania ruchów niepełnych (np. mięsień udowy), jego jednostki motoryczne będą miały wysoki współczynnik unerwienia (tj. każdy neuron ruchowy unerwia 1000 lub więcej włókien mięśniowych), ponieważ nie ma potrzeby stosowania poszczególnych mięśni włókna ulegają wysoce skoordynowanym, zróżnicowanym skurczom w celu wytworzenia delikatnego ruchu.
### 1.1.5 Kontrola siły mięśni
Neuron ruchowy kontroluje siłę wywieraną przez włókna mięśniowe. Istnieją dwie zasady, które rządzą związkiem między aktywnością neuronów ruchowych a siłą mięśni: kod szybkości (tempo odpalania) i zasada (rozmiaru) wielkości.
#### 1.1.5.1 Tempo odpalania
Neurony ruchowe wykorzystują regulację tempa, aby zasygnalizować ilość siły, jaką ma wywierać mięsień. Wzrost szybkości potencjałów czynnościowych wystrzeliwanych przez neuron ruchowy powoduje wzrost siły generowanej przez jednostkę motoryczną. Ten kod jest przedstawiony na rysunku 1.9. mięsień lekko drga, a następnie rozluźnia się z powrotem do stanu spoczynku. Jeśli neuron ruchowy wystrzeli po powrocie mięśnia do stanu wyjściowego, wtedy wielkość następnego skurczu mięśnia będzie taka sama jak pierwszego. Jeśli jednak tempo odpalania neuronu ruchowego wzrasta, tak, że drugi potencjał czynnościowy pojawia się zanim mięsień zrelaksuje się z powrotem do stanu wyjściowego, wtedy drugi potencjał czynnościowy wytwarza większą siłę niż pierwszy (tj. sumuje się siła skurczu mięśnia) Wraz ze wzrostem "szybkostrzelności" całka staje się silniejsza, aż do pewnego limitu. Kiedy kolejne potencjały czynnościowe nie powodują już sumowania się skurczu mięśnia (ponieważ mięsień jest w swoim maksymalnym stanie skurczu), mięsień znajduje się w stanie zwanym tetanus

Rys. 1.9. Wpływ natężenia pików na siłę mięśnia  [Kni20F1.5]
#### 1.1.5.2 Zasada rozmiaru
Gdy do neuronów ruchowych wysyłany jest sygnał, aby wykonać ruch, neurony ruchowe nie są rekrutowane w tym samym czasie lub losowo. Zasada wielkości neuronu ruchowego stwierdza, że ​​wraz ze wzrostem siły sygnału wejściowego do neuronów ruchowych, aktywowane są mniejsze neurony ruchowe i potencjały czynnościowe odpalania przed rekrutacją większych neuronów ruchowych. Można zapytać dlaczego dochodzi do tej uporządkowanej aktywacji? Występują tu zależności podobne jak między napięciem, prądem i rezystancją (prawo Ohma): V = IR. Ponieważ mniejsze neurony ruchowe mają mniejszą powierzchnię błony, mają mniej kanałów jonowych, a tym samym większą rezystancję wejściową. Większe neurony ruchowe mają większą powierzchnię błony i odpowiednio więcej kanałów jonowych; dlatego mają mniejszą rezystancję wejściową. Ze względu na prawo Ohma niewielka ilość prądu synaptycznego wystarczy, aby potencjał błonowy małego neuronu ruchowego osiągnął próg odpalenia, podczas gdy duży neuron ruchowy pozostaje poniżej progu. Wraz ze wzrostem natężenia prądu wzrasta również potencjał błonowy większego neuronu ruchowego, aż do osiągnięcia progu odpalania. (Rys. 1.9)
Ponieważ jednostki motoryczne są rekrutowane w uporządkowany sposób, słabe impulsy do neuronów motorycznych powodują, że tylko kilka jednostek motorycznych jest aktywnych, co skutkuje niewielką siłą wywieraną przez mięsień. Przy silniejszych wejściach rekrutowanych będzie więcej neuronów ruchowych, co skutkuje większą siłą przyłożoną do mięśnia, Ponadto różne typy włókien mięśniowych są unerwione przez małe i większe neurony ruchowe. Małe neurony ruchowe unerwiają wolnokurczliwe włókna; Średniej wielkości neurony ruchowe unerwiają szybkokurczliwe, odporne na zmęczenie włókna; 
a duże neurony ruchowe unerwiają szybkokurczliwe, męczące włókna mięśniowe.
Włókna wolnokurczliwe wytwarzają mniejszą siłę niż włókna szybkokurczliwe, ale są w stanie utrzymać ten poziom siły przez długi czas. Włókna te służą do utrzymywania postawy i wykonywania innych ruchów o niewielkiej sile.
### 1.1.6 Neurony ruchowe gamma
Chociaż włókna śródwrzecionowe nie przyczyniają się znacząco do skurczu mięśni, mają na końcach elementy kurczliwe unerwione przez neurony ruchowe.
Neurony ruchowe dzielą się na dwie grupy. Neurony ruchowe alfa unerwiają włókna pozawrzecionkowe (szkieletowe), silnie kurczące się włókna, które dostarczają moc mięśniom. Neurony ruchowe gamma unerwiają włókna śródrdzeniowe, które kurczą się tylko nieznacznie. Funkcją skurczu śródwrzecionowego włókien nie jest dostarczanie siły mięśniowi, a raczej aktywacja gamma włókna śródrdzeniowego, która jest niezbędna do utrzymania naprężenia wrzeciona mięśniowego, a tym samym wrażliwości na rozciąganie, w szerokim zakresie długości mięśni. W przypadku rozciągnięcia mięśnia grzbietowego, wrzeciono mięśniowe rozciąga się równolegle, wysyłając sygnały za pośrednictwem głównych i drugorzędnych afferentów. Jednak następujący po tym skurcz mięśnia usuwa naciąganie wrzeciona i staje się ono luźne, powodując, że aferenty wrzeciona przestają działać. Gdyby mięsień miał być ponownie rozciągnięty, wrzeciono mięśniowe nie byłoby w stanie zasygnalizować tego rozciągnięcia.
Zatem, wrzeciono staje się tymczasowo niewrażliwe na rozciąganie po skurczu mięśnia. Aktywacja neuronów ruchowych gamma zapobiega tej chwilowej nieczułości, wywołując słaby skurcz włókien nerwowych, równolegle do skurczu mięśnia. Skurcz ten utrzymuje wrzeciono cały czas napięte i utrzymuje jego wrażliwość na zmiany długości mięśnia. Tak więc, gdy centralny system nerwowy wydaje polecenie skurczu mięśnia, nie tylko wysyła odpowiednie sygnały do ​​neuronów ruchowych alfa, ale także instruuje neurony ruchowe gamma, aby odpowiednio skurczyły włókna śródwrzecionowe. Ten skoordynowany proces jest określany jako koaktywacja alfa-gamma. [Kni20]
Na rysunku 1.10 przedstawiono budowę neuronu, z kierunkiem przepływu informacji. 

Rys. 1.10. Budowa neuronu [Przy14]
# 2 Wykorzystane techniki pomiarowe
## 2.1 Zakres badań
Zespół przeprowadził - z istotnym wkładem dyplomanta - eksperyment z udziałem 109 osób. Do zapisu mierzonych sygnałów wykorzystano format WAVE [Wav]. Pojedynczy plik zawiera 8 kanałów nieskompresowanego sygnału EMG spróbkowanego 2048 razy na sekundę. Do pomiaru przygotowano instrukcję z animacją gestów (Patrz Rozdział 2.1.4 Oprogramowanie - QR Code z linkiem).
### 2.1.1 Sprzęt pomiarowy
#### 2.1.1.1 Elektrody
Sensor powierzchniowy DFRobot Gravity [DFR] mierzy indukcyjnie sygnał elektromiograficzny z 1000 krotnym wzmocnieniem (±1.5mV) i wbudowaną filtracją, w szczególności zakłócenia sieciowego. Dane przesyła płytka prototypowa z układem LPC1347 32-bit ARM Cortex-M3 o zegarze 72MHz, z ośmioma kanałami 12-bit ADC konwersją SAR. Następnie transfer danych przejmuje aplikacja desktopowa EMG Analyzer (Patrz Rozdział 2.1.3.1)

Rys. 2.1. Rozmieszczenie opaski z elektrodami na mięśniach ręki
Proponowany przebieg nagrywania w 7-mio sekundowym oknie (stała symboliczna SECONDS), obejmuje 5 sekund aktywności i 1-no sekundowe marginesy relaksacji (ze względu na sekcję początkową i końcową zastosowanego filtru wygładzającego MTF [Duda13] patrz Rodz. 3).
Zaczepy do złączy krawędziowych (tzw. goldpinów) podpina się kolejno, zaczynając od pinu P0_11 (obecnie 8 kanałów).

Rys. 2.2. Płytka LPC 1347 prototypowa sensorów, wykorzystana w badaniach (firmy NXP Semiconductors)

Autor wykonał oprogramowanie (opisane w rozdziale 2.1.3) do wstępnego przetwarzania i wizualizacji mierzonych sygnałów. Przykładowy obraz sygnału, odpowiadający zgięciu palca środkowego i serdecznego tgz. “Spider Man'a” pokazano na rysunku 2.3. Widać na nim efekt sterowania pracą mięśni zginaczy (przy rozluźnionej dłoni widmo jest płaskie).

Rys. 2.3. Obraz widma amplitudowego sygnału EMG wykrywającego pracę mięśni przy zginaniu dwóch palców (jak na fotografii) palca środkowego i serdecznego (wygenerowany przez autorską aplikację Finger EMG - Zał.1)
### 2.1.2 Analiza merytoryczna źródeł zakłóceń i szumów pomiarowych

Zakłócenia sygnału EMG mogą być spowodowane następującymi czynnikami (cytowanie dosłowne z [Woj18]):
Zakłóceniami zewnętrznymi (oddziaływaniem pól magnetycznych urządzeń elektronicznych, które znajdują się w pobliżu miejsca pomiaru, oraz zasilaniem elektrycznym 50 Hz ;
Zakłóceniami spowodowanymi ruchem (wskutek przesunięcia skóry z naklejoną elektrodą w stosunku do badanych  włókien mięśniowych brzuśca oraz ruchów kabla pomiarowego  powodującego zakłócenia w zakresie [0-20] Hz;
Niestabilnością sygnału EMG (spowodowaną częstotliwością pobudzenia jednostek motorycznych w zakresie [0; 20] Hz, przy czym średnia częstotliwość pobudzenia wynosi [15;25] Hz);
Sygnałem EMG pochodzącym  od sąsiednich mięśni (zjawisko nazywanie przesłuchem crosstalking);
Szumami własnymi aparatury pomiarowej;
Efektu zakłócającego owłosienia ręki.

	W monografii [Woj18] (cytat dosłowny), zwraca się uwagę, że: … podczas pomiaru należy zadbać, aby miejsce połączenia elektrody ze skórą nie zmieniało  w  miarę możliwości swoich właściwości fizykochemicznych, tzn. w miejscu pomiaru nie może dochodzić do zmiany wilgotności wskutek pocenia się. 
	W pomiarach miograficznych występuje efekt przesłuchu między sąsiednimi elektrodami (crosstalking). System pomiarowy zabezpieczający przed zjawiskiem składa się z podwójnej elektrody pomiarowej (realizuje różnicową metodę pomiarową) oraz elektrody referencyjnej (uziemienia)
Na Rys. 2.4 (aplikacja autorska FingerEMG) pokazano obraz zakłócenia sieciowego
i obwiednie jego widma, spowodowanego zbliżeniem kabla sieciowego do sensorów.

Rys. 2.4. Widmo amplitudowe zakłócenia sieciowego (cienkie szare słupki) oraz ich obwiednia - linia ciągła zielona. (Widmo jest symetryczne, tu widzimy lewą połowę widma, oś symetrii jest na krawędzi obrazu).
W wyniku prac zespołu została wykonana prototypowa instalacja pomiarowa przedstawiona na rysunku 2.5.

Rys. 2.5. Instalacja prototypowa do analizy sygnałów elektromiograficznych
### 2.1.3 Oprogramowanie systemu pomiarowego
#### 2.1.3.1 Konfiguracja 
Dla potrzeb badań autor wykonał oprogramowanie w języku C/C++ o nazwie FingerEMG do obróbki i wizualizacji mierzonych sygnałów EMG. (pełny listing w zał 2.) Jego kluczowe parametry przedstawia poniżej Listing 1.

Listing 1. Konfiguracja aplikacji EMG Analyzer transferującej sygnał użyteczny.

```cpp
#define DSIZE 4096		        // Data
#define NCH   8			          // Number of Chanels
#define FS    2048			      // Frequency Sampling 
#define QLV_BYTES_PER_WORD 2  // uint16 // Quantisation LeVel, number  
                              // of bytes per variable. Scale factor
#define DSIZE2 (DSIZE/QLV_BYTES_PER_WORD)
 
#define VSIZE (DSIZE2/NCH)    // Vector
#define SECONDS 7             // of recording
#define FRCNT NCH*SECONDS     // 8 channels, 5 seconds
 
#define FFT_SIZE VSIZE*FRCNT  // Fourier Transform Vector Size
```

Z powyższego kodu, wiemy że badany sygnał ma gęstość próbkowania 2048 na sekundę. Zgodnie z kryterium Nyquista maksymalna częstotliwość to 1 KHz, jaką można interpretować ze spektrum, czyli widma Fouriera.
### 2.1.4 Czynności przed zbieraniem sygnałów

Do zbierania powierzchniowych sygnałów biomedycznych została przygotowana instrukcja, której pierwszy podpunkt zamieszczono poniżej. 

Instrukcja zbierania sygnałów sEMG
Przygotowanie przed zbieraniem sygnałów
Przygotowanie skóry
Ułożenie elektrod
Pozycja mięśnia
Gesty prawej dłoni (10)
Przekazanie sygnałów
#### 2.1.4.1 Przygotowanie skóry
Skóra musi zostać odtłuszczona za pomocą płynu dezynfekującego oraz pozbawiona owłosienia.
#### 2.1.4.2 Ułożenie elektrod
Elektroda nr 1 umieszczona na mięśniu ramienno-promieniowym, kolejność kanałów w stronę zewnętrzną, patrząc od strony pacjenta. Należy zwrócić uwagę na ułożenie elektrody względem sprzączki, co pokazano na rysunku 2.6 a). Pozycja mięśnia (branchus radialis) jest obserwowalna przy rotacji dłoni (kciuka).- patrz Rys. 2.6 b)
a)b)
Rys 2.6. Umiejscowienie pierwszej elektrody na pozycji w czerwonym prostokącie [Fiz17]
# 3 Wykorzystane metody przetwarzania sygnałów 
## 3.1 Historyczne początki
Wstępną obróbkę sygnału wykonuje aplikacja autorska FingerEMG — pozwala ona na generowanie widma w przestrzeni Fouriera. W dziedzinie czasu obserwujemy 3 (RGB) fale sinusoidalne. W dziedzinie częstotliwości odpowiadające im 3 (szare) piki  podążające jeden za drugim.

Rys. 3.1. Aplikacja FingerEMG z sygnałami w dziedzinie czasu i częstotliwości (3-ch mnichów)

	W ramach niniejszej pracy, autor - przy współudziale promotora - opracował oprogramowanie w języku Matlab [Matlab21] o nazwie MTFbion,m, którego pełny listing zamieszczono w Zał. 3.
Przetwarzanie sygnału EMG pozyskanego z instalacji pomiarowej w tym programie, obejmuje:
Odczyt sygnałów z plików zapisanych przez aplikację WaveApp i przez skrypt wczytajEMG.m
Obliczenie sygnałów diagnostycznych z kolejnych kanałów,
Analizę widmową sygnałów diagnostycznych, 
Syntezę filtrów dolno i środkowoprzepustową do analizy w czasie rzeczywistym 
Filtrację sygnałów diagnostycznych 
Wizualizację graficzną
## 3.2 Konstrukcja sygnałów diagnostycznych w dziedzinie czasu 
Sygnał diagnostyczny to taki, który niezależnie od sposobu pozyskania uwypukla cechy badanego zjawiska - pracy mięśnia. W omawianym przypadku sygnał ten jest rozumiany jako zmierzoną wraz z zakłóceniami, elektryczną ekspresję woli osoby chcącej wykonać ruch ręką. 
Podstawowe parametry  sygnałów i procedury ich obliczania w języku Matlab, zestawiono w tabeli 2.1 zaczerpniętej ze skryptu [Ziel05].

Tabela 2.1 Przedstawione właściwości sygnału oraz ich oblicznie w Matlabie [Ziel05]

Sygnał surowy i jego przetwarzanie na sygnały diagnostyczne.

Przykład bezpośrednio zmierzonego sygnału EMG pokazano na rysunku 3.1 (sygnał odpowiada zgięciu i wyprostowaniu palca serdecznego). 

Rys. 3.1. Przykład bezpośrednio zmierzonego sygnału EMG.Na czerwono i zielono zaznaczono granice (początek i koniec) przebiegu szeregu poddawanego dalszym analizom 

Kolejne punkty tego ciągu są dalej interpretowane jako zmierzona indukcyjnie suma impulsów przesyłanych do mięśnia pod elektrodą w jednym okresie próbkowania (0.5 ms). W związku z tym przyjęto, że potencjał zgromadzony w mięśniu w celu wywołania ruchu jest sumą tych impulsów (integracja tych sygnałów). W wyniku uzyskuje się sygnał przedstawiony na Rys. 3.2.

Rys 3.2. Sygnał po zsumowaniu - widziany jako wartość zgromadzonego potencjału w mięśniu

Przyjęto również, że efektywny sygnał sterujący pracą mięśnia, można odwzorować przez zastosowanie modelu dynamiki mięśnia jako członu inercyjnego pierwszego rzędu o stałej czasowej M = 20 ms, której wartość oszacowano metodą prób, tak aby poziom szumu wysokoczęstotliwościowego był zbliżony do sygnału bezczynności  (wartość M może być przedmiotem dalszych testów). Efekt takiego przetworzenia zwany sygnałem skumulowanym przedstawia Rys. 3.3

Rys. 3.3. Sygnał sterujący bezpośrednio pracą mięśnia (uzyskany przez zastosowanie dyskretnego modelu dynamiki mięśnia typu AR1(alfa=exp(-dt/M)) . Linia zielona - efekt jego filtracji dolnoprzepustowej.
4.0.1 Znakowana energia jako sygnał diagnostyczny
Ponadto, oprócz omówionego wyżej sygnału w badaniach wykorzystano jeszcze dodatkowy sygnał w postaci znakowanej mocy, pokazany na rysunku 3.4, zdefiniowany jak niżej:
Y2 = sign(Y-Y)(Y2-Y) 			(3.1)
Gdzie Y oznacza wartość średnią. 


Rys. 3.4. Instrumenty sygnał diagnostyczny Y2 (wzór 3.1)

Filtracja dolnoprzepustowa takiego sygnału daje podobne rezultaty jak filtracja sygnału Y, przy około dwukrotnie mniejszym opóźnieniu estymacji w czasie rzeczywistym. Niech w(t) oznacza sygnał będący efektem filtracji dolnoprzepustowej sygnału Y, a vs(t) - efekt filtracji dolnoprzepustowej sygnału Y2. Pożądany sygnał diagnostyczny v(t) oblicza się przez odwrócenie zależności (3.1), tj.  ze wzoru 
v(t) = sign(vs)|vx|+Y 			(3.2)
## 3.3 Analiza widmowa sygnałów diagnostycznych

Analizę widmową finalnego sygnału diagnostycznego (jak pokazany na Rys. 3.3) przeprowadzono w celu zaprojektowania filtrów cyfrowych umożliwiających estymację sygnału sterującego bezpośrednio pracą mięśnia przez usunięcie składowych wysokoczęstotliwościowych interpretowanych jako szum pomiarowy. Do wyliczania widm zastosowano funkcję Matlaba fft() co pozwoliło obliczać moduł amplitud poszczególnych harmonicznych (właściwości fazowe nie mają tu istotnej roli). Wszystkie szeregi poddawane transformacji fft (zawierające oryginalnie 14336 próbek) uzupełniono zerami tak, aby wszystkie badane sygnały (w tym również odpowiedzi impulsowe projektowanych filtrów) były reprezentowane takimi samymi częstotliwościami. Dodawanie zer do transformowanego szeregu, nie zmienia mocy badanego sygnału, a przez zwiększenie okresu podstawowego widma pozwala zwiększyć i ujednolicić rozdzielczość analizy w dziedzinie częstotliwości. Przyjęto jako jednolitą długość szeregu lT0 = 192512 próbek. 
Widmo amplitudowe sygnału pokazanego na Rys. 3.3 przedstawiono na Rys. 3.5 Jak widać obliczone amplitudy wykazują dużą zmienność, co wynika z faktu, iż widmo fft() wyznacza parametry formuły interpolacyjnej dostosowane do wartości sygnału zawierającego składowe losowe. W związku z tym bardziej miarodajną reprezentacją właściwości sygnału użytecznego, jest widmo wygładzone, które pokazano na rysunku 3.5 jako linię czerwoną. Sposób wygładzania omówiono w rozdziale 3.3.

Rys. 3.5. Widmo przykładowego finalnego sygnału diagnostycznego. Linia niebieska - wartości amplitud obliczone fft(), linia czerwona - widmo wygładzone filtrem MTF (patrz Rodz. 3.3). Częstotliwość wyrażono względem częstotliwości granicznej fd=5.3 Hz zastosowanych dalej filtrów dolnoprzepustowych. Pionowe linie pokazują częstotliwości odpowiadające parametrom zastosowanych dalej filtrów

Rysunek 3.5 uwidacznia, że sygnał diagnostyczny ma widmo praktycznie ograniczone do częstotliwości fd = 5.3 Hz jakkolwiek w zakresie częstotliwości do około 5fd przenoszona jest znacząca część mocy. Można stąd wnioskować, że sygnał w paśmie do 1fd reprezentuje zamierzoną czynność motoryczną (wolę), który realnie można wykorzystać do sterowania protezą  dłoni. Natomiast średnoczęstotliwoścową część 1-5fd można traktować jako korekty ruchu w trybie feedback. 
## 3.4 Synteza filtrów cyfrowych 
### 3.4.1 Zasady filtracji cyfrowej 

Filtracja sygnałów ma na celu rozdzielenie sygnału wejściowego na składowe zawierające częstotliwości w idealnym przypadku tylko z założonego przedziału  widma. Tak rozseparowane sygnały nazywa się sygnałami użytecznymi niezawierającymi częstotliwości, które w założeniu nie powinny być obecne w tym sygnale (są traktowane jako szumy). 
W związku z tym filtr idealny powinien mieć prostokątną charakterystykę amplitudową. 
W praktyce jest to nieosiągalne, ale dąży się do konstruowania filtrów o możliwie stromej charakterystyce w pobliżu granicy wymaganego pasma. Zachodzenie amplitud dla sąsiednich pasm jest traktowane jako nieuniknione zniekształcenie amplitudowe pożądanego sygnału. Z drugiej strony nieuchronnym efektem przetwarzania jest przesunięcie fazowe. Jeśli przesunięcie fazowe filtru jest liniową funkcją częstotliwości, to efekt filtracji jest przesunięty względem wejścia o stałą liczbę próbek zwaną przesunięciem grupowym. Jeśli jednak charakterystyka jest nieliniowa, to mamy do czynienia z zniekształceniem fazowym.
Schemat ogólny filtracji cyfrowej przedstawia rysunek 3.6 zaczerpnięty z  podręcznika [Ziel05]. Ilustruje on zasadę działania filtrów jako układu połączeń szeregowo równoległych bloków dyskretnego przetwarzania sygnału. 

Rys. 3.6.  Schemat blokowy filtra cyfrowego dla M = N = 3: a) pełny, b) linia opóźniająca tylko na wejściu,
c) linia opóźniająca tylko na wyjściu. Oznaczenia (angielskie): FIR − Finite Impulse Response, IIR − Infinite
Impulse Response, ARMA − Autoregressive Moving Average, MA − Moving Average, AR − Autoregressive
 [Ziel05]
Filtry cyfrowe dzielą się na rekursywne i nierekursywne. Filtr rekursywny jest blokiem typu ARMA, to znaczy jego transmitancja jest funkcją wymierną, której mianownik reprezentuje przetwarzanie sygnału wcześniej przetworzonego (wyjścia), natomiast licznik - przetwarzanie sygnału wejściowego. Jego reprezentacja w dziedzinie czasu, czyli odpowiedź impulsowa (odpowiedź czasowa na impuls Diraca) jest ciągiem nieskończonym, stąd nazwa -  filtry typu IIR (Infinite Impulse Response). Filtr rekursywny musi być stabilny, to znaczy pierwiastki wielomianu charakterystycznego wynikające z formuły mianownika transmitancji, muszą leżeć w kole jednostkowym. Jest to warunek konieczny poprawnej pracy filtru. Rzędy licznika i mianownika są niewysokie (1 do 5).
Filtry nierekursywne w dziedzinie zmiennej z reprezentuje wyłącznie licznik transmitancji (obiekt typu MA), co oznacza że przedmiotem przetwarzania jest tylko sygnał wejściowy, co można widzieć jako średnią ważoną jego wartości w oknie o określonej długości. Filtr taki ma zatem gwarantowaną stabilność. Odpowiedź impulsowa jest ciągiem skończonym, stąd nazwa - filtry FIR (Finite Impulse Response) - którego długość jest szerokością przesuwanego okna czasowego. Jednak dla uzyskania wymaganej jakości filtracji długość ciągu musi być na ogół bardzo duża (kilkaset próbek). Główną zaletą filtrów nierekursywnych jest uzyskanie liniowego przesunięcia fazowego, którego efekt można wyeliminować przez uwzględnienie stałego opóźnienia.
### 3.4.2 Synteza filtrów FIR typu MTF

Na podstawie właściwości widmowych pokazanych na rysunku 3.4 przyjęto, że odtworzenie w czasie rzeczywistym sygnału sterującego mięśniem wymaga zastosowania filtrów dolnoprzepustowych o częstotliwości granicznej fd = 5.3 Hz i odpowiednio stromej charakterystyce amplitudowej. 
W celu zaprojektowania filtrów pozwalających możliwie wiernie odtworzyć sygnał sterujący, w pierwszym etapie badań przeprowadzono identyfikację sygnałów sterujących z wykorzystaniem  filtrów  FIR opracowanych przez opiekuna [Duda13], zwanych filtrami typu MTF (Moving Trend Filters), implementujących wygładzanie metodą trendu pełzającego. Metoda ta polega na uśrednianiu wartości aproksymat szeregu uzyskanych w przesuwanym oknie przez zastosowanie wielomianu stopnia od 1 do 5, z wykorzystaniem wybranych jednomianów. Technikę projektowania takich filtrów i ich właściwości omówiono obszernie w publikacji [Duda13], a zasadę projektowania filtrów wykorzystanych w tej pracy zaprezentowano na Rys. 3.7. 
Wygodnym i intuicyjnym parametrem projektowym tych filtrów jest częstotliwość fd, dla której charakterystyka amplitudowa osiąga pierwsze minimum (częstotliwość graniczna). Typowy parametr, to jest częstotliwość połówkowego tłumienia mocy, wyznacza się numerycznie. 
Filtracja MTF prowadzona jest jest w 3-ch segmentach; startowym i końcowym o długości okna aproksymacji M proporcjonalnej do wartości 1/fd oraz w segmencie centralnym o dowolnej długości obejmującym pozostałą część szeregu. Filtracja centralna jest w istocie wygładzaniem szeregu bez zniekształcenia fazowego i może być wykorzystana do identyfikacji sygnału użytecznego. Połówkowa długość segmentu końcowego jest stałym opóźnieniem czasowym wyniku filtracji. Filtracja w segmencie końcowym wprowadza niestety bardzo duże zniekształcenia amplitudowe. W niniejszej pracy zastosowano filtr MTF z  jednomianami rzędu od 0 do 3, wykazujący dużą stromość opadania charakterystyki amplitudowej. 
W celu zwiększenia stromości opadania tej charakterystyki i wyeliminowaniu efektu wycieku widma zastosowano kaskadę dwóch szeregowych filtrów dolnoprzepustowych, Jako drugi przyjęto filtr o wartości fd2= 1.2fd, dla której filtr 1-wszy  ma drugie maksimum charakterystyki amplitudowej. Efekt zastosowania takiej metody pokazano na Rys. 3.7-3.9. 

Rys. 3.7. Ilustracja metody projektowania  filtru MTF i filtru Butterwortha. Fzwc oznacza wynikowy filtr dolnoprzepustowy  (linie niebieskie); Fzwd -  1-szy filtr MTF dla fd=5.3 H (linie czerwone); Fzw2 - drugi filtr MTF dla fd= 6.4 Hz (kolor magenta);  Ffc - filtr sekcji końcowej dla chwili bieżącej (kolor zielony); Ff1 - pierwszy filtr końcowy dla chwili bieżącej (linie cyan); Ff2 - drugi filtr końcowy dla sekcji bieżącej (linie cyan - przerywane)  Pod rysunkiem linie czarne filtr Butterwortha 5-tego rzędu o częstotliwości odcięcia takiej jak dla Fzwd. Pod rysunkiem dolnym podano opóźnienia: stałe dla MTF, a dla Butterwortha - uśrednione kolejno do częstotliwości kolejno hP połowicznego tłumienia mocy fd częstotliwości fd, A01częst. dla amplitudy 0.01


Na Rys. 3.7 widać, że uzyskana charakterystyka amplitudowa ma bardzo korzystne właściwości, to znaczy dużą stromość opadania i praktycznie zerową amplitudę dla częstotliwości większych od fd. Jak wspomniano wyżej charakterystyka fazowa jest liniowa, lecz wynikające z niej stałe opóźnienie filtracji jest duże. Dla przyjętej wartości fd = 5.3 Hz opóźnienie tau wynosi 765 ms, Wynika ono z sumowania opóźnień filtru pierwszego i drugiego. Opóźnienie filtru pierwszego wynosi 354 ms, ale  wykorzystanie tylko tego filtru wprowadziłoby dosyć znaczące zniekształcenia amplitudowe, tj. mniejszą stromość opadania charakterystyki i wyraźny wyciek widma dla  f> fd. Z tego względu do analiz w czasie rzeczywistym znacznie lepiej jest zastosować filtr rekursywny Butterwortha, który wprowadza znacznie mniejsze opóźnienie. 
Rysunek 3.7 pokazuje ewidentnie, że filtr końcowy (linie cyan przerywane) jest nieprzydatny, ani do analizy w czasie rzeczywistym, ma duże zniekształcenia fazowe i opóźnienie w związku z tym w badaniach wykorzystano tylko filtr centralny, który potraktowano jako filtr wygładzający. Właściwości tego filtru w powiększonej skali przedstawia Rys. 3.8.

Rys. 3.8. Ilustracja właściwości amplitudowych i fazowych projektowanych jak na Rys. 3.6 z uwypukleniem właściwości filtru wykorzystanych dalej.

W celu zbadania właściwości średnioczęstotliwościowych sygnałów diagnostycznych zaprojektowano drugi filtr dolnoprzepustowy o znacznie szerszym paśmie przyjmując częstotliwość graniczną fg= 21.2 Hz. Został on zastosowany do filtracji obliczonych reszt filtracji dolnoprzepustowej, z uwzględnieniem opóźnienia filtru dolnoprzepustowego. Właściwości tego filtru zilustrowano na rysunku 3.9. Uzyskany filtr ma opóźnienie łączne  952 ms, a więc bardzo duże, dlatego również do analizy właściwości średnoczęstotiwoścowych w czasie rzeczywistym zaprojektowano filtr Butterworth. 
Filtr MTF dla szeregów diagnostycznych Y i sygnału znakowanej mocy Y2 (patrz wzór 3.1) przyjęto jako metodę estymacji sygnału referencyjnego w przeszłości, który wykorzystano do analizy istotności zniekształceń wprowadzanych przez filtr rekursywny. 
Rys. 3.9. Właściwości filtru środkowoprzepustowego, Czerwony przerywany - pierwszy filtr dolnoprzepustowy; ciągły magenta 2-gi filtr dolnoprzepustowy; niebieski przerywany pierwszy filtr górny dolnoprzepustowy; niebieski ciągły - drugi filtr  górny dolnoprzepustowy
### 3.4.3 Projektowanie filtrów Butterwortha

Filtr Butterworth jest powszechnie uznanym filtrem rekursywnym (IIR) pozwalającym na uzyskanie w czasie rzeczywistym korzystnych estymat sygnału identyfikowanego, z nieznacznymi zniekształceniami amplitudowymi, ale z nieuniknionymi zniekształceniami fazowymi, których istotność została oceniona przez porównanie z wynikiem filtracji MTF. 
Parametrem projektowym jest rząd i częstotliwość połówkowego tłumienia mocy, którą określa się jako współczynnik wc=2f0/fhP, tj. stosunek połowy częstotliwości podstawowej f0=1/T0, (ustalanej arbitralnie stosownie do wymaganej rozdzielczości przez założenie długości T0/dt szeregu poddawanego transformacji fft) do wymaganej częstotliwości połówkowego tłumienia mocy fhP. Przyjęto filtr 5-go rzędu jako dający najlepsze właściwości, a nie powodujący problemów numerycznych. Wartość fhP przyjęto taką jak uzyskana dla filtru wynikowego MTF. Wyznaczono ją numerycznie według charakterystyki amplitudowej filtru wynikowego dolnoprzepustowego MTF. 
Porównanie charakterystyki amplitudowej i fazowej uzyskanego filtru przedstawiono na rysunkach 3.7 i 3.8. Widać na nich, że filtr Butterwortha ma podobnie właściwości amplitudowe jak MTF, ale nieco korzystniejszą charakterystykę amplitudową do częstotliwości fhP, i mniej korzystną dla wyższych częstotliwości (wolniejsze opadanie amplitudy) Rys. 3.10 przedstawia szczegółowo właściwości tego filtru z uwypukleniem nieliniowości charakterystyki fazowej. Aproksymaty linowe tej charakterystyki wykreślono liniami przerywanymi. Uzyskano je przez uśrednienie stosunku przesunięcia fazowego do częstotliwości dla wszystkich punktów w zakresie od 0 do fhP, od 0 do fd i od 0 do fA01. Takie uśrednianie odpowiada ważonej aproksymacji minimalnokwadratowej z  wagami 1/f2 Zniekształcenie jest istotne dla wyższych częstotliwości niż fhP. W wyniku przeprowadzonych testów, stwierdzono że najmniejsze zniekształcenia fazowe występuje gdy jako opóźnienie grupowe przyjmiemy średnie opóźnienie aproksymaty hP i fd Wartości tych opóźnień zastępczych dla filtrów zastosowanych w dalszych badaniach pokazano na Rys. 3.9. Widać tam, że filtr Butterwortha daje opóźnienie ponad 4 krotnie mniejsze niż filtr końcowy MTF. 

Rys. 3.10. Właściwości przykładowego filtru Butterwortha 5-tego rzędu (ftu oznacza fd). Częstotliwość wyrażono względem fd. Linia ciągła na rysunku dolnym jest charakterystyką fazową. Linie przerywane — aproksymaty linowe tej charakterystyki uzyskane przez uśrednienie stosunku przesunięcia fazowego do częstotliwości dla wszystkich punktów w zakresie od 0 do kolejno:  fA01- linia zielona, fd- linia niebieska, do fhP - linia czerwona ciągła, czerwona przerywana - średnia przyjęta w badaniach.


# 4 Badania właściwości sygnałów diagnostycznych EMG
## 4.1 Cel badań i przeprowadzone eksperymenty
Celem badań było stwierdzenie na ile sygnał diagnostyczny odzwierciedla wolę osoby wykonującej określone ruchy palcami i dłonią. Przyjęto, że ekspresją woli jest składowa wolnozmienna sygnału, sterująca w założeniu pracą mięśni, którą można realnie odtworzyć sygnałami elektrycznymi, w celu oddziaływania na cięgna protezy generujące zamierzone ruchy. Do takiego odtwarzania zastosowano narzędzia omówione w rozdziale 3.
W badaniach wzięło udział 109 osób,  które były proszone o wykonywanie odpowiednich gestów w czasie 5 sekund, z 1-no sekundowym brakiem aktywności przed i po wykonaniu gestu. Okresy bezczynności były potrzebnie dla umożliwienia pełnej identyfikacji sygnału reprezentującego gest przy pomocy filtrów MTF, które wprowadzają opóźnienie około 0.8s. Każdy zapisany gest był rejestrowany w ośmiu kanałach z częstotliwością około 2kHz (patrz Rozdział 2). Wszystkie szeregi zapisano na plikach (*.wav). Zastosowano następujący sposób identyfikacji cyfrowej i tekstowej plików odpowiadających poszczególnym gestom we wszystkich 8-miu kanałach.

```matlab
% Numeracja gestów
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x 00 - Reference noise 
% x 01 - Moutza moc
% x 02 - Zaciśnięta pięść, kciuk na zewnątrz
%   03 - Gest OK
%   04 - palec wskazujący
% c 05 - kciuk w górę
%   06 - słuchawka
%   07 - Łapwica
%   08 - Otwieranie dłoni
%   09 - Zginanie palców po kolei
%   10 - trzymanie przedmiotu
% z 11 - Victoria - statyczne
%   12 - odliczanie - dynamiczne
% z 13 - Three middle fingers closer - 3 palce środkowe  statyczne
%   14 - moc - dynamiczne
%   15 - pięść - dynamiczne
%   16 - victoria dynamiczne
%   17 - 3 środkowe palce razem - dynamiczne
% c 18 - serdeczny palec w środek dłoni (like Spiderman)
%   19 - mały palec
```

Każdą osobę poproszono o wykonanie różnych gestów. Ponadto ten sam gest wykonywały różne osoby lub powtarzała ta sama osoba, w celu zbadania podobieństwa reprezentacji jednakowych gestów. Strukturę każdego z plików pokazuje rysunek 4.1.

Rys. 4.1. Zasada oznaczania plików z gestami 

Do oznaczenia numeru osoby wykorzystano cyfry kodujące na trzech pozycjach poprzedzających tekst rozszerzenia nazwy pliku.  
	Badania zarejestrowanych sygnałów obejmowały:
Zastosowanie autorskiej aplikacji Finger EMG (napisanej w języku C/C++) do wstępnego przetworzenia i zarejestrowania w plikach jw. sygnałów surowych (bezpośrednie zmierzonych przy pomocy instalacji pomiarowej przedstawionej w rozdziale 2) 
Ergonomiczna wizualizacja sygnałów i ich widm przy pomocy autorskiej aplikacji Finger EMG 
Wykorzystanie  aplikacji MTFbion.m przygotowanej we współpracy z opiekunem, implementującej w języku Matlab metody omówione w rozdziale 3, do identyfikacji gestów we wszystkich 8-miu kanałach, wykonywanych przez kolejne osoby oraz prezentacja graficzna wyników na rysunkach dla poszczególnych kanałów i rysunkach zbiorczych zostawiających wyniki estymacji badanego gestu przez poszczególne osoby.
W dalszej części pracy w Rodz. 4.2, z konieczności opisano wyniki tylko niektórych, reprezentatywnych eksperymentów.
## 4.2 Omówienie reprezentatywnych wyników badań
### 4.2.1 Badania zgięcia palców
Spośród wielu badanych gestów zgięcie palca jest w odczuciu autora bardzo interesujące. 
Na Rys. 4.2 pokazano obraz (wytworzony przy pomocy aplikacji FingerEMG) przebiegów czasowych sygnałów generowanych przez zgięcia poszczególnych palców.

Rys 4.2. Przebiegi czasowe sygnałów odpowiadających gestom kolejno 01, 02, 11, 13 w poszczególnych kanałach od góry 1 do 8
Warto zwrócić uwagę, że stan bezczynności (obraz lewy) generuje sygnały losowe o małej zmienności nieco różniące się w poszczególnych kanałach. Jeśli przyjąć, że sygnały takie stanowią tło EMG w każdej aktywności mięśni, oznacza to, że tło nie odgrywa istotnej roli dla identyfikacji dla poszczególnych sygnałów sterujących ruchem mięśni.  Przy wykonywaniu gestów widać duże zróżnicowanie sygnałów w poszczególnych kanałach, najbardziej na rysunku prawym, natomiast zaciśnięcie dłoni (2-ga kolumna) angażuje jak widać wiele mięśni (w kanałach 4, 5, 6, 8). 
Rysunek 4.3 pokazuje widmo sygnału zmierzonego w jednym kanale, wygenerowanego wskutek zgięcia palca serdecznego oraz widmo wygładzone przez uśrednianie w przedziałach rozdzielczych częstotliwości (widmo słupkowe - Finger EMG) . Wyraźnie widać średnioczęstotliwościowy charakter sygnału.
Rys 4.3. Widmo częstotliwościowe charakterystyczne dla powierzchniowego badania mięśni
	W celu zbadania stacjonarności widma w trakcie wykonywania różnych gestów, w aplikacji FingerEMG obliczano widmo amplitudowe w przesuwanym oknie o różnej długości. Wykresy 4.4 i 4.5 przedstawiają wyniki takiej analizy dla cyklicznego gestu zaciskania pięści. Wartość amplitudy odwzorowano kolorem, oś rzędnych przedstawia czas bieżący. Widać, że sygnały mają charakter niskoczęstotliwościowy, a rozszerzanie okna powoduje interakcję poszczególnych etapów pracy mięśnia. Wynika stąd, że do analizy widma w  czasie rzeczywistym należy przyjąć raczej krótkie okno. 

Rys 4.4. Widma sygnału cyklicznego zaciskania pięści, wyliczonych w oknie o różnych długościach

Rysunek 4.5 obrazuje widma amplitudowe dla tego samego sygnału po jego filtracji pasmowej 10-500 Hz filtrem Butterwortha 5-tego rzędu. Operacja ta zwiększa rozdzielczość czasową widm odpowiadającym poszczególnym aktywnościom.
		


Rys 4.5. Analiza częstotliwościowa oddziaływania filtracji i okna czasowego

Kompleksową analizę sygnałów w poszczególnych kanałach odpowiadającym badanym gestom prowadzono dalej z wykorzystaniem aplikacji MTFbion.m  Analiza ta obejmowała: przetwarzanie sygnału wejściowego oryginalnego na sygnał diagnostyczny to jest sumowanie sygnału i przetworzenie modelem AR1 na sygnał Y, wyliczenie sygnału instrumentalnego Y2, tzw. znakowanej mocy (wg. wzoru 3.1)   Obliczenie widm amplitudowych Y i Y2. Filtrację obu sygnałów przy pomocy dolnoprzepustowych filtrów MTF i Butterwortha środkowoprzepustowych przy pomocy MTF, i wygładzenie uzyskanych otrzymanych widm o wartości fd= 10Hz. Przy wygładzaniu widm opóźnienie filtru MTF zredukowano dla najniższych częstotliwości, przeprowadzając filtrację startową w odpowiednim zakresie liczb ujemnych (wykorzystanie symetrii widma)  Dalej przedstawione zostaną wyniki dla ruchu palców, konkretnie gestu zginania palca serdecznego. 
Na początku zbadano funkcję korelacji wzajemnej sygnałów we wszystkich kanałach, z przesunięciem czasowym od jednej do 20 próbek (0.5ms do 10ms). Rysunek 4.6 pokazuje, że korelacje przesuniętych w czasie sygnałów w poszczególnych kanałach są niezbyt wysokie, ale istotne statystycznie. Można przyjąć, że wynikają z współdziałania mięśni, których sygnały EMG mierzymy w poszczególnych kanałach. Warto zaznaczyć, że korelacje te są względnie wysokie dla kanałów sąsiadujących ze sobą: kanał 1 z kanałami 2 i 8, kanał 7 z kanałami 6 i 8,

Rys. 4.6. Wartości współczynników korelacji wzajemnej sygnałów, z sygnałami z pozostałych kanałów z przesunięciem od 0 do 20 próbek ( dla poprawienia czytelności nie pokazano autokorelacji)


Wyniki kompleksowej analizy w oknie rejestracji tych sygnałów przedstawiają rysunki 4.7 do 4.9. Na rysunku 4.7 - wykres 2.1 - porównano sygnał Y z efektem jego filtracji dolnoprzepustowej wykonanej przy pomocy filtru MTF (linia czerwona) z uwzględnieniem opóźnienia i z efektem filtracji Butterwortha5 (linia zielona) bez uwzględnienia opóźnienia. Oba efekty filtracji (MTF i Butter) są uwidocznione na wykresie 3.1,  bez przesunięcia sygnału Butterwortha i z przesunięciem. 

Rys. 4.7. Zbiorcza analiza sygnału surowego dla kanału drugiego (numeracja wykresów od lewego górnego rogu) 1.2 sygnał zsumowany; 1.3  filtry dolnoprzepustowe dla sygnału Y i Y2; 1.4 filtr pasmowy; 2.1 sygnał Y (po zastosowaniu modelu  AR1); 2.2 Widmo amplitudowe sygnału Y; 3.1 Trend wolnozmienny; 3.2 Widmo obliczone (czerwone), wygładzone (czarna linia); 4.1 średnio częstotliwościowy sygnał korekcyjny; 4.2 Widmo obliczone (cyan), wygładzone (czarny); 2.3 sygnał znakowanej mocy Y2 z rysunku 2.1, przekształcony (wzorem 3.2) do sygnału V; 2.4 Widmo Y2; 3.3 Trend sygnału V; 3.4 Widmo Y2; 4.3 średnoczęstotliwościowy sygnał korekcyjny dla sygnału V; 4.4 Widmo obliczone (cyan)  sygnału  Y2 (4.3)  wygładzone (czarny). Znaczenie linii pionowych jak na rysunkach 3.1 - 3.10

Wykresy 3.1 i 3.3 na rysunku 4.7 wykazują, że efekt filtracji Butterwortha po przesunięciu o opóźnienie zachowuje się jak wynik filtracji MTF przy ponad czterokrotnie mniejszym opóźnieniu. Wynik ten potwierdzają wykresy na rysunkach 4.8 i 4.9, które zestawiają przebiegi trendów wolnozmiennych i średnioczęstotliwościowych uzyskane dwoma badanymi filtrami, po uwzględnieniu ich opóźnień, dla badanego gestu w każdym kanale. Te wykresy wskazują, że różnice trendów wolnozmiennych MTF i Butterworth5 są nieistotne. Oznacza to, że filtr Butterwortha jest znacznie lepszym narzędziem estymacji wolnozmiennych składowych sygnałów EMG niż filtry MTF, gdyż jak wykazano w obliczeniach,  jego zniekształcenia fazowe są nieistotne. Podobny wniosek można wysnuć na podstawie efektów filtracji sygnału Y2 w dwukrotnie szerszym paśmie i przekształconych wzorem (3.2) do sygnału trendu oznaczonego symbolem V (Rys. 4.7 wykresy 2.3 i 3.3, Rys. 4.8 wykresy w dwóch dolnych rzędach). Warto zauważyć, że trendy wolnozmienne sygnału V są bardzo podobne do efektów filtracji sygnału Y, przy czym uzyskano je przy pomocy filtrów o 2-krotnie szerszym paśmie, a więc z 2-krotnie mniejszym opóźnieniem. Widać to wyraźniej na rysunku 4.9, gdzie pokazano efekty zastosowania tych czterech metod na wykresach łącznie dla każdego kanału. Przebiegi tych trendów są praktycznie nieodróżnialne. Wynika stąd do estymacji trendów wolnozmiennych najlepiej jest zastosować filtrację Butterwortha5 sygnału znakowanej mocy Y2i wynik filtracji przekształcić do sygnału V wg wzoru (3.2). Daje to ponad 9-cio krotne mniejsze opóźnienie filtracji, niż zastosowanie filtru MTF dla sygnału Y, bez istotnych zniekształceń. (MTF = 785 ms, Butterworth = 83 ms)
Rys. 4.8. Zestawienie efektów filtracji dolnoprzepustowej MTF i Butterwortha5, po uwzględnieniu opóźnień, dla poszczególnych kanałów. Dwa rzędy górne wykresów - trendy wolnozmienne uzyskane przez filtrację sygnału Y, dwa rzędy dolne - trendy wolnozmienne Y2 przekształcone wzorem 3.2 do sygnału V.

Sygnał średnioczęstotliwościowy pokazany zbiorczo na Rys. 4.9 dla poszczególnych kanałów w dolnych dwóch rzędach wykresów, wykazuje brak regularności  i duże zróżnicowanie dla czterech omówionych wyżej metod filtracji. Oznacza to w praktyce, że nie może on być wykorzystany bezpośrednio jako sygnał korygujący ruch. Do korekty wymagane będzie zastosowanie sprzężenia zwrotnego. 

Rys. 4.9. Zestawienie zbiorcze efektów filtracji, z uwzględnieniem opóźnień, sygnału Y filtrami MTF i Butterwortha5 (linie czarne) oraz  sygnału  Y2 tymi filtrami o 2-krotnie szerszym paśmie ( a więc dwukrotnie mniejszym opóźnieniu), po przekształceniu sygnału przefiltrowanego Y2 do sygnały V wg. 3.2 (linie czerwone) dla poszczególnych kanałów. Dwa rzędy górne wykresów - trendy wolnozmienne; dwa rzędy dolne - trendy środkowoczęstotliwościowe. 


# 5 Zakończenie
W pracy przeprowadzono badania sygnałów EMG dłoni wykorzystując analizę częstotliwościową i skonstruowane na tej podstawie filtry cyfrowe do estymacji w czasie rzeczywistym sygnału sterującego ruchem mięśni w trybie feedforward (sygnał ten można widzieć jako ekspresję woli ruchu człowieka). Jako model fizyczny biologicznego działania ruchu przyjęto sumowanie impulsów EMG wysyłanych do mięśni i autoregresję rzędu pierwszego do odwzorowania dynamiki mięśni. Badaniom poddano tak uzyskane sygnały diagnostyczne oraz ich transformację w postaci znakowanych kwadratów wartości sygnału, co pozwala dwukrotnie zmniejszyć opóźnienie estymacji. 
Przyjęto, że reprezentacją woli osoby wykonującej gest jest efekt dolnoprzepustowego wygładzania odpowiedniego sygnału diagnostycznego, bez zniekształcenia fazowego przy pomocy dedykowanego filtru FIR [Duda13] oraz filtrów rekursywnych Butterwotrha. 
Wykazano, że do estymacji sygnału sterującego ruchem w czasie rzeczywistym można wykorzystać filtr Butterwortha piątego rzędu o takiej samej częstotliwości połowiczego tłumienia mocy, jak w filtrze wygładzającym FIR, uwzględniając opóźnienie wynikające z liniowej aproksymacji przesunięcia fazowego w istotnym zakresie widma (w przybliżeniu stałe opóźnienie grupowe). Odwzorowywuje to właściwości amplitudowe sygnału z ponad czterokrotnie mniejszym opóźnieniem niż filtr FIR. Wykazano też, że bardzo podobne efekty daje estymacja sygnału sterującego ruchem na podstawie sygnału diagnostycznego będącego znakowanym sygnałem mocy (kwadrat próbek sygnału rzeczywistego), co daje 2-wu krotnie mniejsze opóźnienie.
Uzyskane wyniki można widzieć jako punkt wyjścia do dalszych badań, ukierunkowanych na określenie zależności między wymuszeniami, jakie powinny być podane na cięgna protezy, a sygnałami omówionymi w tej pracy. Istotnym problemem jest określenie wzorców sygnałów woli, możliwie jednolitych dla różnych osób wykonujących ten sam gest.

# 6 Bibliografia 

Zdjęcia nieopisane pochodzą z materiałów własnych.
[0] Anne Urai "CHOICE INDUCED BIASES IN PERCEPTUAL DECISION MAKING"	 Medizinischen Fakultät der Universität Hamburg, 2018	
[1] Jan T. Duda "Modele matematyczne struktury i algorytmy nadrzędnego sterowania komputerowego" Wydawnictwa AGH, Kraków 2003	
[2] Witold Byrski "Obserwacja i sterowanie w systemach dynamicznych" Wydawnictwa AGH, Kraków 2007
[3] Tadeusz Kaczorek "Teoria sterowania i systemów" Wydawnictwo Naukowe PWN, Warszawa 1993
[4] Metafizyczne zasady wszechświata. Kartezjusz Newton Leibniz	https://ruj.uj.edu.pl/xmlui/bitstream/handle/item/245757/sytnik-czetwertynski_metafizyczne_zasady_wszechswiata_2006.pdf?sequence=1&isAllowed=y (21.01.2022)	
[5] Poukładać matematykę (lub przynajmniej próbować https://www-users.mat.umk.pl/~grzegorz/r1.pdf (12.01.2022)		
[ABC 07] http://www.dydaktyka.ib.pwr.wroc.pl/materialy/MDP002002L%20Fizjologia/ABC%20EMG.pdf (10.01.2022)		
[Cich98] https://www.researchgate.net/publication/2773278_Blind_Source_Separation_and_Deconvolution_of_Fast_Sampled_Signals (10.01.2022)		
[Del93] https://delsys.com/downloads/TUTORIAL/the-use-of-semg-in-biomechanics.pdf	(22.01.2022)	
[DFR] https://wiki.dfrobot.com/Analog_EMG_Sensor_by_OYMotion_SKU_SEN0240 (22.01.2022)	
[Duda13] https://annals-csis.org/proceedings/2013/pliks/444.pdf (22.01.2022)			
[Fiz14] https://fizjoterapeuty.pl/uklad-nerwowy/potencjal-czynnosciowy.html (22.01.2022)		
[Fiz17] https://fizjoterapeuty.pl/wp-content/uploads/2017/03/miesien-ramienno-promieniowy-441x600.jpg ) (22.01.2022)	
[HipFiz11] https://fizjoterapeuty.pl/fizjologia/hiperplazja-miesni.html (22.01.2022)
[Kni20_1.4] https://nba.uth.tmc.edu/neuroscience/m/s3/images/copyright_marked_images/html_5_conversions/1-3_NEW.jpg (22.01.2022)
[Kni20] James Knierim https://nba.uth.tmc.edu/neuroscience/m/s3/chapter01.html (10.01.2022)		
[Luca02] https://www.delsys.com/downloads/TUTORIAL/semg-detection-and-recording.pdf (10.01.2022)	
[Matlab21] https://www.mathworks.com/help/pdf_doc/matlab/index.html (22.01.2022)		
[Pie22] Design and verification of bionic hand control using EMG signal PWSZ, Tarnów 2022
[Przy14] Promieniowanie elektromagnetyczne a zdrowie / Maria Przybylska. - Zielona Góra : Uniwersytet Zielonogórski	 2014.	
[Reaz06] https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1455479/pdf/bpo_v8_p11_m115.pdf (dostęp 12.12.2021)		
[Tad11] Informatyka Medyczna http://mariuszrurarz.cba.pl/wp-content/uploads/2016/09/Informatyka-Medyczna-tadeusiewicz.compressed.pdf Uniwersytet Marii Curie-Skłodowskiej w Lublinie, Lublin 2011	
[Tech06] Techniques of EMG signal analysis: detection processing classification and applications Online 2006 (22.01.2022)
[Wav] https://pl.wikipedia.org/wiki/WAV (22.01.2022)		
[WikiPro] https://pl.wikipedia.org/wiki/Proprioreceptor (22.01.2022)
[Win15] Dawid Winiarski The use of EMG signal in human-machine interface https://journals.bg.agh.edu.pl/AUTOMAT/2015.19.2/automat.2015.19.2.47.pdf (14.01.2022)		
[Woj18] Biomechaniczne modele układu mięśniowo-szkieletowego człowieka / Wiktoria Wojnicz. - Wydanie I. - Gdańsk : Wydawnictwo Politechniki Gdańskiej 2018.	
[Ziel05] Tomasz P. Zieliński Cyfrowe przetwarzanie sygnałów od teorii do zastosowań Warszawa	WKŁ, 2005
[Ziel94] Tomasz P. Zieliński Reprezentacje sygnałów niestacjonarnych typu czas-skala i czas-częstotliwość Kraków,	 Wydawnictwa AGH 1994	
BodyWorks: EMG Neuromuscular Simulation http://articlesbyaphysicist.com/muscle_emg.html	(22.01.2022)
EMG Wave Processing EMG Analysis Tool http://www.articlesbyaphysicist.com/emg_waves.html  (22.01.2022)

# 7 Aneks - Sygnał ⚡ Obiekt 📽️ Model 💭 
## 7.1 Podstawy - metajęzyk abstrakcji, pośredniczący w osiąganiu celu
Mapy względności pojęcia słownictwa eksperta dziedzinowego

## 7.2 Dziedzina określa ograniczenie warstwy eksperckiej znaczenia słów
Dla przykładu "eksperymentu myślowego" weźmy słowo: switch
Dla każdego technika "myśl" będzie znaczyć co innego:
elektronik zapewne opowie o przycisku,
programista o instrukcji warunkowej,
a informatyk przykładowo pomyśli o urządzeniu sieciowym.
Słowo jest jedno, ale kontekst czy też scena się zmienia, dlatego .. . "Kropki" W. Markowicza to język formalny (jak Matematyka), który znajdzie zastosowanie nie tylko w "ściśle wyważonym" inżynierskim słownictwie.
## 7.3 Czym różni się obiekt od modelu?
Dziedziną
abstrakcja jest uproszczeniem rzeczywistości, w sensie formalnym badań. Najczęściej mówi się o umownym, warstwowym modelu odpowiedzialności i zależności.
Obiekt - dziedzina Rzeczywista (to co jest obserwowalne/osiągalne)
Model - dziedzina Abstrakcyjna (nasze wyobrażenia jaki obiekt jest)
Dlaczego do notowania wykorzystywane są mapy myśli i ciągi przyczynowo skutkowe?
Jest to przestrzeń dla rozwoju dziedzin naukowych, nierozłącznie empirycznych. Metoda mat 👆 teo 👇 info o reprezentacji kierunku paradygmatu, perspektywiczno-poznawczej: natężenia wizji (inter) czasowej oraz napięcia atmosfery (multi) przestrzennej. W nauce w przypadku innym, niż szczególny; bitowy (zdarzenie o prawdopodobieństwie 1/2) teoria przeczy praktyce. (Wynika to z komputerowego sposobu wykonywania obliczeń)

Postawmy sobie teraz pytanie, jak subiektywnie są rozumiane słowa użyte na powyższym diagramie?

Problem / przypadek / węzeł -

Dziedzina / czasoprzestrzeń / ograniczenia -

Wyprostowanie / zagęszczenie / rozwiązanie -
Problem nieporozumienia nie leży w mnogości języków, ale w sposobie ich interpretacji. Tworząc nowe, mamy nadzieję, że rozwiążą problemy poprzednich. Nawiązując do średniowiecznego sposobu zapisu współczesnego słowa “będą”, można zauważyć jak ważne jest zbadanie kontekstu historycznego. [https://.cgithubom/jsbien/unicode4polish/blob/master/uninasal.pdf]
## 7.4 Przypadki użycia (Use Case from UML)

## 7.5 Budowanie modelu

## 7.6 Rozwój Liniowej Dynamiki


Warto przypomnieć sobie podstawy opisu sygnałów, ich modulacji do przenoszenia informacji przez; amplitudę, okres i opóźnienie.
Ekstrakcji cech można dokonać; strukturalnie dzieląc na słowa i zdania, statycznie filtrując lub transformując, albo użyć metod neuronowych. Rozważa się zbudowanie teorii Rozwoju Liniowej Dynamiki, będącej w korespondencji do obecnych hipotez.







https://pl.wikipedia.org/wiki/Jednostka_motoryczna
https://nba.uth.tmc.edu/neuroscience/m/s3/chapter01.html

### Materiały i metody

Eksperyment przeprowadzono z udziałem 109 osób. Do zapisu wykorzystano format WAVE. Pojedynczy plik zawiera 8 kanałów nieskompresowanego sygnału EMG z próbkowanego 2048 razy na sekundę.
Do pomiaru przygotowano instukcję z animacją gestów. https://github.com/informacja/EMG/tree/master/matlab/instrukcja#readme
Proponowany przebieg nagrywania w 7-mio sekundowym oknie 5 sekund aktywności i 1-no sekundowe marginesy relaksacji (ze względu na sekcje początkową i końcową filtra MTF).
Badany sygnał ma częstotliwość próbkowania 2048 na sekundę.

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

### Design desMTFcButter
```matlab
%... Argumenty obowiązkowe
% nTypzZ - numer typu MTF - ma być 5 lub 3
% Tud - okresy harmonicznej odcięcia widma MTF (indeks 1.szego min(A(i))
% ....... Dalej argum. opcjonalne:
% rzad rzad filtru Butterwortha, np.: [3 4 5]; UWAGA: gdy rzad=0 lub nargin<3 nie liczymy Butter
% lT0 liczba probek w okresie podstawowym (np 10000); domyślnie lT0=0 tzn. nie liczymy widm
% fig nr rysunku np.1 lub: 0 - nastepny lub brak - bez rysunkow
% kolB tablica kolorow dla Butterwortha, jesli pusty kolB='k' 
% txtyt - tytul, np: sprintf('Porownanie filtrow Butter i MTF dla Tu=%.0f lT0=%d',Tu,lT0), lub sprintf('Wykresy Bodego dla filtrow Butter. rzędu 5 4 3 i Tu=%.2f; lT_0=%d',rzedu,Tu,lT0); 
% ................................... Przykład najprostszy ..............
% [[bf, af, tauhP, MTFd, Fzwc, LpFc]=desMTFcButter(nTypZ,Tud)
% .......................................................................
```

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

