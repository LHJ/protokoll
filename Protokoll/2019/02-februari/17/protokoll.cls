% variables% Det här är en classfil för att skriva protokoll.
%% Den är främst baserad på protocol.cls av Rahman Amanullah från 19990130
%% Jon Larsson, 2003-07-30
%% Martin Nygren, 2005-06-07
%% Jesper Särnesjö, 2006-10-13, justeringsman -> justeringsperson
%% John Elfberg Larson, 2017-06-02 -- 2017-06-08, omdesign av mall.tex samt tillägg av nya kommandon


%
%			Inledande gunk (paket, avstånd m.m.)
%

\def\fileversion{v1.04}
\def\filedate{2017/06/02}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{protokoll}[\filedate\ \fileversion]

\RequirePackage{ifthen}
\RequirePackage{graphicx,calc}
\RequirePackage[a4paper]{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[swedish]{babel}
\RequirePackage{lmodern}
\RequirePackage{xparse}
\RequirePackage{arrayjob}
\RequirePackage{etoolbox}
%\RequirePackage{lstdoc}
%\RequirePackage[utf8]{inputenc}

\newboolean{@pdfoutput}
\DeclareOption{pdftex}{\setboolean{@pdfoutput}{true}}
\DeclareOption{dvips,pdftex}{\PassOptionsToPackage{geometry,graphicx}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions

\LoadClass[a4paper]{article}
\geometry{top=3cm, bottom=3cm, left=2.9cm, right=2.9cm, footskip=10ex}

%% Avstånd
\setlength{\parindent}{0pt}
\setlength{\parskip}{1.2ex}

%% Om en bildfil är vald så gäller följande avstånd
%% Anledningen till två definitioner är för att användaren skall kunna
%% ändra bredden på bilden.
\newlength{\bildwidth}					% Bredden på bilden.
\newlength{\bildsep}
\setlength{\bildwidth}{11em}
\setlength{\bildsep}{1em}

%% Avst. mellan bild och text.
\newlength{\@bildwidth}
\newlength{\@bildsep}
\setlength{\@bildsep}{5pt}
\setlength{\@bildwidth}{0pt}

%% Några korta avstånd.
\providecommand{\ts}{\thinspace}
\providecommand{\tts}{\kern .11111em}
\providecommand{\ttts}{\kern .05556em}

%
%			Variabler
%

%% Booleska variabler.
\newboolean{@twojust}					% Finns det två justeringsmän?
\newboolean{@motesnr}					% Mötesnummer?
\newboolean{@ordf}						% Ordförande?
\newboolean{@ordftitel}                 % Ordförande titel?
\newboolean{@sekr}
\newboolean{@sekrtitel}
\newboolean{@onejust}
\newboolean{@bild}
\newboolean{@behorighet}                % Är mötet behörigt?
\newboolean{@adjung}             % Har vi några adjungeringar?

%% Kommandon för att sätta variabler

\newcounter{Cadjung}
\newcounter{iAdjung}
\newarray\Adjungs
\providecommand{\adjung}[1]{
    \stepcounter{Cadjung}
    \Adjungs(\value{Cadjung})= {#1}
    \setboolean{@adjung}{true}
}
%asd
\providecommand{\behorighet}[1]{\gdef\@behorighet{#1}\setboolean{@behorighet}{true}}
\providecommand{\bild}[1]{\gdef\@bild{#1}\setboolean{@bild}{true}}
\providecommand{\plats}[1]{\gdef\@plats{#1}}
\providecommand{\typ}[1]{\gdef\@typ{#1}\gdef\@typet{#1t}}
\providecommand{\motesnr}[1]{\gdef\@motesnr{#1}%
  \setboolean{@motesnr}{true}}
\providecommand{\datum}[1]{\gdef\@datum{#1}}
\providecommand{\tid}[2]{\gdef\@tid{#1 - #2}%
    \gdef\@starttid{#1}%
    \gdef\@stopptid{#2}}
\providecommand{\organ}[1]{\gdef\@organ{#1}}
\providecommand{\organisation}[1]{\gdef\@organisation{#1}}

\ProvideDocumentCommand{\ordf}{ m o }{
    \gdef\mordf{#1}
    \setboolean{@ordf}{true}
    
    \IfValueTF{#2}
    {\gdef\mordftitel{#2}
    \setboolean{@ordftitel}{true}}
    {\gdef\mordftitel{}}
}

\ProvideDocumentCommand{\sekr}{ m o }{
    \gdef\msekr{#1}
    \setboolean{@sekr}{true}

    \IfValueTF{#2}
    {\gdef\msekrtitel{#2}
    \setboolean{@sekrtitel}{true}}
    {\gdef\msekrtitel{}}
}

\providecommand{\justA}[2]{\gdef\mjustA{#1}\gdef\mjustAtitel{#2}%
  \setboolean{@onejust}{true}}
\providecommand{\justB}[2]{\gdef\mjustB{#1}\gdef\mjustBtitel{#2}%
  \setboolean{@twojust}{true}}
\providecommand{\forordf}[1]{\gdef\fordf{#1}}%

%% Skriv ut variabler
\providecommand{\skrivforordf}{\fordf\hspace{1 mm}}
\providecommand{\skrivordf}{\mordf\hspace{1 mm}}
\providecommand{\skrivordftitel}{\mordftitel\hspace{1 mm}}
\providecommand{\skrivsekr}{\msekr\hspace{1 mm}}
\providecommand{\skrivsekrtitel}{\msekrtitel\hspace{1 mm}}
\providecommand{\skrivjustA}{\mjustA\hspace{1 mm}}
\providecommand{\skrivjustAtitel}{\mjustAtitel\hspace{1 mm}}
\providecommand{\skrivjustB}{\mjustB\hspace{1 mm}}
\providecommand{\skrivjustBtitel}{\mjustBtitel\hspace{1 mm}}


%% Är allting angivet?
%\providecommand{\chmotesnr}{\ifthenelse{\boolean{@motesnr}}{}{%
%    \typeout{VARNING: Inget motesnummer angivet.}}}
\providecommand{\chordf}{\ifthenelse{\boolean{@ordf}}{}{%
    \typeout{VARNING: Ingen motesordforande angiven.}\ordf{Valfrid%
    Lindeman}}}
\providecommand{\chsekr}{\ifthenelse{\boolean{@sekr}}{}{%
    \typeout{VARNING: Ingen motessekreterare angiven.}\sekr{Valfrid%
    Lindeman}}}
\providecommand{\chjust}{\ifthenelse{\boolean{@onejust}}{}{%
    \typeout{VARNING: Ingen justeringsperson angiven.}\justA{Valfrid%
    Lindeman}}}
    \providecommand{\chbehor}{\ifthenelse{\boolean{@behorighet}}{}{%
    \typeout{VARNING: Ingen behörighet angiven.}}}

%
%			Formateringskommandon
%

%% Punkter är sections och att-satser är items
\let\punkt\section
\let\subpunkt\subsection
\let\att\item

\newcounter{cUPunkt}
\newcounter{cUPunktCheck}
%\providecommand{\subpunkt}{
%    \ifthenelse{ %If
%    \equal{ \arabic{cUPunktCheck} } { \arabic{section} } } 
%    { %Then } 
%    { %Else 
%    \setcounter{cUPunkt}{0} 
%    }
%    
%    \stepcounter{cUPunkt}
%    \setcounter{cUPunktCheck}{\arabic{section}}
%    \hspace{0.5cm}\arabic{section}.\arabic{cUPunkt}. 
%    }
%}

%% Adjungeringar
%\newcounter{adj}
%\providecommand{\adjungeringar}{
%    \foreach \n in {adjungs}{}

%% Paragraftecken
\providecommand{\§}{\S\ts}

%% Inledande versal
\def\Capthis#1{\uppercase{#1}}
\def\capthis#1{\expandafter\Capthis#1}

%% Sätter rubrik i protokollshuvudet
\providecommand{\rubrik}[1]{\textsf{#1}}

%% En person i närvarolistan, #1 = Förnamn Efternamn, #2 = Titel tillika titel
\providecommand{\moteperson}[2]{& #1 & #2\\}

\newcounter{iPersoner}
\newcounter{Pcount}
\newarray\Personer

\providecommand{\person}[2]{%
    \stepcounter{Pcount}%
    \Personer(\value{Pcount})={& #1 & #2\\}
}

%% Skriv ut mötesfakta
\providecommand{\skrivtid}{\skrivdatumtid} % Alias för \skrivdatumtid
\providecommand{\skrivdatumtid}{\\ \rubrik{Tidpunkt} & %
  \multicolumn{2}{l}{\@datum,\ \@tid}\\}
\providecommand{\skrivplats}{\\ \rubrik{Plats} & %
  \multicolumn{2}{l}{\@plats}\\}
\providecommand{\narvarande}{\\ \rubrik{Närvarande}}
\providecommand{\franvarande}{\\ \rubrik{Frånvarande}}

%
%			Övriga kommandon
%

%% För att skriva ut hur många sidor totalt som finns.
%% Lånat från lastpage-paketet av Jeff Goldberg från 940625.
\def\lastpage@putlabel{%
    \immediate\write\@auxout{\string
    \newlabel{LastPage}{{}{\thepage}}}%
}

%
%			Miljöer
%

%% Beslut
\newenvironment{beslut}{%
  %% Början
  \par\vspace{1ex}%
  \textbf{\@organ\ beslutade}%
  \vspace{-1ex}%
  \begin{list}{\emph{att}}{}}
  %% Slutet
  {\end{list}}

%% Protokollhuvudet (mötesfakta)
\newenvironment{motesfakta}{%
  %% Början
  \begin{tabular}{@{\hspace{-0.27em}}l l l}}
  %% Slutet
  {\end{tabular}%
   \vspace{2ex}}

%
%			Pagestyle
%

%% Kontrollerar om ordförande och justeringsperson är angivna och sätter
%% sedan ut sidfoten beroende på om en eller två justeringsmän är
%% angivna.
\providecommand{\ps@protokoll}{%
  \renewcommand{\@oddhead}{\emph{\@organisation\hfill\capthis\@typ\space%
      \@datum\hfill\thepage (\pageref{LastPage})}}%
  \renewcommand{\@evenhead}{\@oddhead}%
  \renewcommand{\@oddfoot}{%
    \chjust\footnotesize\ifthenelse{\boolean{@twojust}}{%
      \parbox[l]{\textwidth}{%
        \begin{tabular}{@{}p{4cm} l  @{\hspace{1cm}} p{4cm} l%
            @{\hspace{1cm}} p{4cm}}
          \cline{1-1}\cline{3-3}\cline{5-5}\\[-2ex]
          \mjustA & & \mjustB & & \mordf\\
        \end{tabular}}}{%
      \parbox[l]{\textwidth}{%
        \begin{tabular}{@{} p{5.5cm} c @{\hspace{2cm}} p{5.5cm}}
        \cline{1-1} \cline{3-3}\\[-2ex]
        \mjustA & & \mordf\\
      \end{tabular}}}}%
  \renewcommand{\@evenfoot}{\@oddfoot}}

%% Sista sidan ska inte ha justeringssidfot
\providecommand{\ps@lastpage}{%
  \renewcommand{\@evenfoot}{}%
  \renewcommand{\@oddfoot}{}}

%
%			Dokumentets början och slut
%

%% Blandade initialvärden
\pagestyle{protokoll}
\typ{styrelsemöte}
\organisation{Maxwells Demoner}
\usepackage[utf8]{inputenc}

%% Fixa förstasidan
\AtBeginDocument{%
  \phantom{Tjoho}%
  \vspace{0.5cm}%
  %% Använd en bildfil om den är angiven.
  \ifthenelse{\boolean{@bild}}%{\IfFileExists{\@bild}%
    {\setlength{\@bildwidth}{\bildwidth}%
      \setlength{\@bildsep}{\bildsep}%
      \parbox[l]{\@bildwidth}{%
        \ifthenelse{\boolean{@pdfoutput}}{%
          \pdfimage width \@bildwidth \@bild}{%
          \includegraphics[width=\@bildwidth]{\@bild}}}
      \parbox[l]{\@bildsep}{}%}%
    }{}%{\typeout{VARNING: Filen \@bild\ kan inte hittas.}}}{}%
  \parbox{\textwidth-\@bildwidth-\@bildsep}{%
    \textbf{\LARGE Protokoll fört vid \@typ\ \ifthenelse{\boolean{@motesnr}}%
      {nr~\@motesnr\ }}\\[1ex]
    \textsc{\LARGE \@organisation}}\\[1ex]
	\vspace{0.5cm}%
   
     \begin{motesfakta}
        \skrivdatumtid
        \skrivplats
        \narvarande
        \moteperson{\skrivordf}{\ifthenelse{\boolean{@ordftitel}}
            {\skrivordftitel tillika mötesordförande}
            {Ordförande}
        }
        \moteperson{\skrivsekr}{\ifthenelse{\boolean{@sekrtitel}}
            {\skrivsekrtitel tillika mötessekreterare}
            {Sekreterare}
        }
        \moteperson{\skrivjustA}{\skrivjustAtitel tillika justeringsperson} % ex. Medlem tillika justeringsperson
        \moteperson{\skrivjustB}{\skrivjustBtitel tillika justeringsperson} % ex. Medlem tillika justeringsperson
        \whiledo{\value{iPersoner} < \value{Pcount}}{%
            \stepcounter{iPersoner}%
            \Personer(\value{iPersoner})%
        }
    \end{motesfakta}

    \punkt{Mötets högtidliga öppnande}
    \skrivordf förklarade mötet öppnat \@starttid.
    
    \punkt{Formalia}
    \begin{enumerate}
    \item{\textbf{Val av mötesordförande}

    \skrivordf valdes till mötesordförande.}

    \item{\textbf{Val av mötessekreterare}
            
    \skrivsekr valdes till mötessekreterare.}

    \item{\textbf{Val av två justeringspersoner tillika rösträknare}

    \skrivjustA och \skrivjustB valdes till justeringspersoner.}

    \item{\textbf{Mötets behöriga utlysande}

    \ifthenelse{\boolean{@behorighet}}
    {\@typet~anses vara obehörigt på grund av \@behorighet.} % then
    {\@typet~förklaras behörigt.} % else
    }

    \item{\textbf{Eventuella adjungeringar}

    \ifthenelse{\boolean{@adjung}}
    { % THEN
        \begin{beslut}
        \att inadjungera~%
        \addtocounter{Cadjung}{-1}%
        \stepcounter{iAdjung}%
        \whiledo{\value{iAdjung} < \value{Cadjung}}{%Adjung >= 3
            \Adjungs(\the\value{iAdjung}),~\stepcounter{iAdjung}%
        }%
        \ifthenelse{\value{Cadjung} > 0}% Resterande Adjung = 2 
        {
            \Adjungs(\the\value{Cadjung})~och\stepcounter{Cadjung}~\Adjungs(\the\value{Cadjung})~med närvarorätt, yttranderätt, förslagsrätt, dock ej rösträtt.
        }{%else Adjung = 1
            \Adjungs(\the\value{Cadjung})~med närvarorätt, yttranderätt, förslagsrätt, dock ej rösträtt.
        }
        \end{beslut}
    }
    {Inga adjungeringar.} % else
    }
    \end{enumerate}
}

%% Sist i protokollet ska underskrifterna skrivas ut
\AtEndDocument{
    \punkt{Mötets högtidliga avslutande}
    \skrivforordf förklarade mötet avslutat \@stopptid.
    
    %\pagestyle{lastpage}\thispagestyle{protokoll}
  \vspace{2cm}\chordf\chjust\chsekr%
  \ifthenelse{\boolean{@twojust}}{\parbox[b]{15cm}{%
      \begin{tabular}{@{} p{6cm} l @{\hspace{2cm}} p{6cm}}
        \cline{1-1}\cline{3-3}\\[-2ex]
        {\footnotesize\msekr, mötessekreterare} & &
        {\footnotesize\mordf, mötesordförande}\\[1.5cm]
        \cline{1-1}\cline{3-3}\\[-2ex]
        {\footnotesize\mjustA, justeringsperson} & &
        {\footnotesize\mjustB, justeringsperson}\\
      \end{tabular}}}{\parbox[b]{15cm}{
      \begin{tabular}{@{} p{6cm} l @{\hspace{2cm}} p{6cm}}
       \cline{1-1}\cline{3-3}\\[-2ex]
       {\footnotesize\msekr, mötessekreterare} & &
       {\footnotesize\mordf, mötesordförande}\\[1.5cm]
       \cline{1-1}\\[-2ex]
       {\footnotesize\mjustA, justeringsperson} & &\\
      \end{tabular}}}
  \thispagestyle{lastpage}
  \ifthenelse{\equal{\pageref{LastPage}}{\thepage}}{}{\typeout{}%
    \typeout{TYPSÄTT ÄNNU EN GÅNG FÖR ATT FÅ RÄTT SISTA SIDA!}%
    \typeout{}}
  \lastpage@putlabel}
