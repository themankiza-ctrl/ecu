# Kiza OBD 1.6 · Telemetrija i analiza menjača

Android aplikacija za snimanje podataka menjača Audi Q5 8R 2.0 TFSI sa automatskim menjačem **0B5/DL501 S tronic**. Podržava ELM327 preko klasičnog Bluetootha (SPP) ili Wi-Fi veze (TCP). Za snimanje je potreban odgovor upravljačke jedinice kompatibilnog menjača.

## Snimanje

1. Dok je vozilo parkirano, priključi adapter i uključi kontakt. U aplikaciji dodirni **Poveži adapter**. Za Bluetooth prvo upari adapter u podešavanjima telefona. Za Wi-Fi se poveži na mrežu adaptera i unesi njegovu IP adresu i port.
2. Proveri identifikaciju i broj očitanih kanala. Aplikacija proverava odgovore kontrolera i prikazuje dostupna očitavanja.
3. Dodirni **Pokreni snimanje** pre polaska. Snimanje se nastavlja sa ugašenim ekranom.
4. Kada se parkiraš, dodirni **Zaustavi i sačuvaj**, pa **Izvezi CSV**. Aplikacija pokušava da priloži kodove grešaka menjača na početku i na kraju snimka.

Za probu bez vozila dodirni **Isprobaj demo**. Grafikon odmah prikazuje simuliranu istoriju. Snimak počinje tek kada dodirneš **Pokreni snimanje**, a demo snimci imaju oznaku `demo` u nazivu i koloni izvora.

## Analiza snimka

1. Završi snimanje i dodirni **Analiziraj snimak**. Možeš otvoriti i ranije sačuvane Kiza OBD snimke.
2. Proveri broj dostupnih kanala i status očitavanja grešaka pri povezivanju i po završetku vožnje. Kodovi imaju status pri svakom očitavanju. Stariji CSV zapisi sa praznim poljem za DTC mogu imati nepoznat status skeniranja.
3. Izaberi **Linija**, **Mapa** ili **3D stubovi**. Dodirni **Prikaži** kod nalaza za skok na njegovu vremensku oznaku. Kursor, vrednosti i klizač prate izabrani trenutak. Snimak možeš pustiti brzinom **×1**, **×2**, **×4** ili **×8**. Stavka **Očitani kanali** obuhvata ceo snimak.
4. Za proveru bez vozila pokreni demo, snimi nekoliko desetina sekundi, sačuvaj snimak i otvori analizu. Demo snimci su označeni kao simulirani.

### Prikazi telemetrije

- **Linija** prikazuje temperature, ulazno i izlazno vratilo i stepen prenosa na usklađenim vremenskim osama. **Ceo snimak** vraća početni opseg, a **Detalj 60 s** bira do jednog minuta oko kursora. Za direktan skok otvori **Promene stepena**. U celom prikazu dužih snimaka prikaz je sažet po vremenskim intervalima uz čuvanje lokalnih maksimuma i minimuma. Koristi detalj za gušći prikaz. Nedostajuće očitavanje se prikazuje crticom.
- **Mapa** prikazuje prosečno apsolutno odstupanje odnosa vratila od medijane istog stepena, izraženo u procentima. Ose su stepen prenosa i obrtaji izlaznog vratila. Dodir polja prikazuje prosek, vrh i broj uzoraka i postavlja kursor na vrh. Ako nema dovoljno stabilnih uzoraka za odnos vratila, izaberi **Temperatura ulja**.
- **3D stubovi** prikazuju stvarna očitavanja iz poslednjih 60 sekundi do kursora, po grupama koje taj snimak sadrži.

Brzina vozila u km/h i stvarno proklizavanje kvačila nisu dostupni među ovim OBD kanalima. Zato se u prikazu koriste merene brzine vratila u o/min i izračunato odstupanje njihovog odnosa. Svi prikazi rade iz lokalnog CSV snimka.

Analiza koristi period kada je menjač identifikovan kao **DL501/0B5** i kada su potrebni kanali očitani. Nalazi uključuju:

- **Kodove kontrolera** sa početnim i završnim statusom. Za kodove P17CF00, P17D000, P17D800 i odgovarajuće kodove viljuški prikazuje se značenje i mogući prateći simptom. Vreme skeniranja označava trenutak očitavanja koda.
- **Temperature** i njihov porast tokom najviše 30 sekundi. Pravila izdvajaju porast od najmanje 12 °C za ulje, 22 °C za pojedinačno kvačilo i 15 °C za kontroler. Odvojeno se prikazuje razlika između dva kvačila od najmanje 25 °C kroz najmanje 12 sekundi dostupnih očitavanja.
- **Odnos vratila** prema medijani najmanje 20 očitavanja u istom stepenu prenosa. Potrebni su stabilan stepen, dovoljno naknadnih merenja i održano odstupanje. Analiza prikazuje i učestalo prebacivanje između dva susedna stepena.
- **Adaptacije** uključuju promenu dostupnih brojača uspešnih i neuspešnih adaptacija i prekid kontinuiteta ako se brojač smanji.
- **Obuhvat podataka** uključuje opseg i broj očitavanja po kanalu, veće pauze i nepotpune ili nečitljive podatke.

Pragovi su pravila za izdvajanje događaja u snimku. Nalazi opisuju očitavanja ili obrazac za proveru. Za potvrdu uzroka važni su uslovi vožnje, konkretan simptom i ciljana dijagnostička merenja. Dostupni kanali ne sadrže pritisak kvačila, zahtevani stepen, obrtaje motora ni kompletan skup podataka o kvačilu. Tokom snimanja aplikacija koristi postojeće komande za čitanje kontrolera.

## Očitavanja i grafikon

- Stepen prenosa, obrtaji ulaznog i izlaznog vratila, temperatura ulja i temperature oba kvačila.
- Dodatno, kada kontroler vrati odgovarajući odgovor, temperatura kontrolera, brojači uspešnih adaptacija oba kvačila i brojač neuspešnih adaptacija kvačila 2. Brojači se samo očitavaju.
- Prikaz **3D stubovi** raspoređuje očitavanja po vremenu i kanalu. Izaberi grupu temperatura, obrtaja vratila, brojača adaptacija ili stepena prenosa. Svaki stub je poslednje stvarno očitavanje u svom intervalu od pet sekundi, a prazna mesta su intervali bez očitavanja. Kanali u grupi imaju zajedničku skalu. Boja prati visinu na skali.
- Prevuci po grafikonu za promenu ugla. **Rotiraj** aktivira animaciju kamere, a **Vrati ugao** vraća početni položaj. U WebGL prikazu uštini za zum. Dodir stuba prikazuje kanal, tačnu vrednost i vreme. Prikaz **Linija** prikazuje jedan izabrani kanal u poslednjih 60 sekundi.
- Aplikacija češće očitava stepen prenosa i obrtaje, a temperature i brojače ređe. U CSV-u prazno polje znači da taj kanal u datom uzorku nije očitan ili da odgovor nije sadržao upotrebljivu vrednost. Brzina uzorkovanja zavisi od adaptera i kontrolera.

Snimak sadrži UTC vreme, proteklo vreme, trajanje očitavanja i podatke menjača. Svaki red se odmah upisuje u datoteku aplikacije. Snimanje se završava nakon dva sata ili pri gubitku veze. CSV snimci sačuvani u ranijim verzijama dostupni su za izvoz iz aplikacije.

3D graf koristi **Apache ECharts 5.6.0** i **ECharts GL 2.0.9** iz lokalnih APK resursa. ECharts GL zahteva ECharts 5.1.2 ili noviji u verziji 5.x. Prikaz radi bez interneta i automatski koristi nativne stubove kada WebGL nije dostupan. Licence su priložene uz biblioteke u `app/src/main/assets/obd-chart`.

CSV u verziji 1.5 ima dodatnu poslednju kolonu `tcm_dtc_scan` za kvalitet odgovora kontrolera. Postojeće kolone imaju isti redosled.

Očitavanja zavise od verzije softvera konkretnog kontrolera. Definicije su proverene prema dostupnim javnim snimcima Q5 8R. Podršku na konkretnom vozilu iz 2008. treba proveriti preko stvarnog adaptera. Aplikacija koristi dijagnostičke zahteve za čitanje podataka.

## Izrada i provera

Na Linuxu instaliraj Android SDK Platform 35, Android Build Tools 35.0.0, JDK 17 ili noviji i `zip`. Podesi `ANDROID_HOME` na putanju SDK-a i pokreni `./build.sh`. Skripta kreira `build/Kiza-OBD.apk` i proverava potpis. Za nadogradnju postojeće instalacije koristi isti ključ za potpisivanje.

Za proveru bez adaptera kompajliraj `AdapterException.java`, `Obd.java`, `ElmConnection.java`, `AudiQ5.java`, `Q5Demo.java`, `RoadLog.java`, `RoadChartHistory.java`, `RoadBarGrid.java`, `RoadRecording.java`, `RoadAnalysis.java`, `ShaftRatios.java`, `RoadTelemetry.java` i Java datoteke u `tests/`. Pokreni `rs.kiza.obd.ProtocolCheck`, `rs.kiza.obd.Q5ProtocolCheck`, `rs.kiza.obd.RoadAnalysisCheck` i `rs.kiza.obd.RoadTelemetryCheck`. Za ECharts testove pokreni `node tests/ChartContractCheck.cjs` i `node tests/TelemetryChartCheck.cjs`.

## Tehnički izvori

- [Audi Service Training SSP 429, motori i menjači za Q5](https://content.datarunners.net/content/SSP/994429AG.pdf)
- [OBDb definicije signala i dostupni zapisi za Audi Q5](https://github.com/OBDb/Audi-Q5) (CC BY-SA 4.0). Definicije kanala u `AudiQ5.Channel` prilagođene su iz ovog izvora i koriste [licencu CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
- [Audi DL501, kodovi proklizavanja kvačila](https://static.nhtsa.gov/odi/tsbs/2025/MC-11012486-0001.pdf)
- [Audi DL501, kod ograničenja momenta zbog temperature kvačila](https://static.nhtsa.gov/odi/tsbs/2016/MC-10118341-9999.pdf)
- [ECharts GL](https://github.com/ecomfe/echarts-gl)
- [ELM327 tehnička dokumentacija](https://www.elmelectronics.com/wp-content/uploads/2016/07/ELM327DSH.pdf)
