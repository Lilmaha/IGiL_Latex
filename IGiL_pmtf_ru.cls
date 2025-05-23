\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pmrf_ru}[2025/05/23 Custom Patch for REVTeX]

\LoadClass[aps,prl,reprint]{revtex4-2}
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\RequirePackage{xpatch}
\RequirePackage{graphicx}
% ШАПКА
\xpatchcmd{\title}
  {\@title{#1}}
  {\gdef\@title{\large\sf #1}}
  {}{\ClassWarning{pmrf_ru}{Failed to patch \title}}

\xpatchcmd{\author}
  {\@author{#1}}
  {\gdef\@author{\large\sf #1}}
  {}{\ClassWarning{pmrf_ru}{Failed to patch \author}}

\xpatchcmd{\affiliation}
  {\@affiliation{#1}}
  {\gdef\@affiliation{\small\sf #1}}
  {}{\ClassWarning{pmrf_ru}{Failed to patch \affiliation}}

\let\oldabstract\abstract
\let\endoldabstract\endabstract
\renewenvironment{abstract}[1][\z@]
  {\advance\abstwidth by #1\relax\oldabstract\small\baselineskip4mm}
  {\endoldabstract}

\newcommand{\UDC}[1]{%
  \gdef\@UDC{\vspace*{-5mm}{\scriptsize \if#1** \vphantom{У} \else#1 \fi}\par}%
  \apptocmd{\maketitle}{\@UDC}{}{}%
}

\newcommand{\DOI}[1]{%
  \gdef\@doi{10.15372/PMTF20#1}%
  \apptocmd{\maketitle}{\scriptsize DOI: \@doi\par}{}{}%
}

\newcommand{\keywords}[1]{%
  \apptocmd{\maketitle}{%
    \vspace*{4mm}%
    \begin{center}%
      \parbox[t]{\abstwidth}{\baselineskip4mm%
      \hspace*{6mm}\small{\sf Ключевые слова:} #1}%
    \end{center}%
  }{}{}%
}

\xpretocmd{\maketitle}
  {\thispagestyle{fancyplain}}
  {}{\ClassWarning{pmrf_ru}{Failed to patch \maketitle}}

\newcommand{\submissiondate}[2]{%
  \apptocmd{\enddoc@text}{%
    \vskip10mm%
    \hfill%
    \parbox{75mm}{\small%
      \if#2**%
        \centerline{\it Поступила в редакцию \sl#1 \it г.}%
      \else%
        \centerline{\it Поступила в редакцию \sl#1 \it г.,}%
        \centerline{\it в окончательном варианте --- \sl#2 \it г.}%
      \fi%
    }%
  }{}{}%
}

\newcommand{\setupheaders}[3]{%
  \pagestyle{fancy}%
  \fancyhead[LE]{\footnotesize #2}%
  \fancyhead[RO]{\footnotesize ПРИКЛАДНАЯ МЕХАНИКА И ТЕХНИЧЕСКАЯ ФИЗИКА. #1. Т. #3}%
  \fancyhead[RE,LO]{\footnotesize\thepage}%
}

% КАРТИНКИ
\preto{\includegraphics}{%
  \@ifnextchar[{\@igwithopt}{\@igwithoutopt}%
}

\newcommand{\@igwithopt}[2][]{%
  \IfFileExists{#2.pdf}{\def\@tmpopt{#1}\expandafter\oldincludegraphics\expandafter[\@tmpopt]{#2.pdf}}{%
    \IfFileExists{#2.png}{\def\@tmpopt{#1}\expandafter\oldincludegraphics\expandafter[\@tmpopt]{#2.png}}{%
      \IfFileExists{#2.eps}{\def\@tmpopt{#1}\expandafter\oldincludegraphics\expandafter[\@tmpopt]{#2.eps}}{%
        \ClassError{mypatchrevtex}{File #2.{pdf/png/eps} not found}{}%
      }%
    }%
  }%
}

\newcommand{\@igwithoutopt}[1]{%
  \IfFileExists{#1.pdf}{\oldincludegraphics{#1.pdf}}{%
    \IfFileExists{#1.png}{\oldincludegraphics{#1.png}}{%
      \IfFileExists{#1.eps}{\oldincludegraphics{#1.eps}}{%
        \ClassError{mypatchrevtex}{File #1.{pdf/png/eps} not found}{}%
      }%
    }%
  }%
}

\let\oldincludegraphics\includegraphics

\newcommand{\TwoCaption}[5]{%
  \begin{subfigure}{#1mm}\centering\small#4\end{subfigure}%
  \hspace{#2mm}%
  \begin{subfigure}{#3mm}\centering\small#5\end{subfigure}%
}

% ТАБЛИЦЫ
\apptocmd{\hline}{%
  \noalign{\vskip 0.8ex}%
  \noalign{\rule[2ex]{0pt}{0.8ex}}%
}{}{}

\newcommand{\hhline}{%
  \noalign{\ifnum0=`}\fi%
  \hrule height 1.2pt%
  \futurelet\@tempa\@xhline%
}

\newcommand{\tabox}[1]{%
  \kern-0.5em%
  \begin{tabular}{c}\\[-4pt]#1\\[2pt]\end{tabular}%
  \kern-0.7em%
}

\newcommand{\labox}[1]{%
  \kern-0.5em%
  \begin{tabular}{l}\\[-4pt]#1\\[2pt]\end{tabular}%
  \kern-0.7em%
}

\newcommand{\vup}{\rule{0pt}{1.6ex}\ignorespaces}
\newcommand{\vDn}{\raisebox{-2.3mm}}{\rule{0pt}{1mm}\ignorespaces}

% БИБЛИОГРАФИЯ
\NewDocumentCommand{\authors}{m}{%
  \def\PMTF@authList{#1}%
}

\NewDocumentEnvironment{Authors}{}{%
  \begin{list}{}{\leftmargin8mm\topsep4mm}%
    \item\footnotesize\normalsize\PMTF@authList%
  \end{list}%
}{%
}

\NewDocumentCommand{\affil}{m}{%
  \def\PMTF@affil{%
    \begin{list}{}{\leftmargin8mm\topsep5mm}%
      \item%
      \footnotesize\normalfont{#1}%
    \end{list}%
  }%
}

\renewcommand*{\thebibliography}[1]{
  \par\noindent\vspace{5mm}%
  \noindent\centering
  \centerline{\large\bfseries\refname}%
  \vspace{-1ex}%
  
  \small%
  \list{[#1].}{%
    \setlength{\labelwidth}{2em}%
    \setlength{\labelsep}{0.5em}%
    \setlength{\leftmargin}{3em}%
    \setlength{\itemsep}{-1mm}%
    \usepackage{enumerate}%
    }
    
  \let\item\olditem%
  \def\newblock{\hskip .11em plus .33em minus .07em}%
  \sloppy\penaltypenalty4000\widowpenalty4000%
  \sfcode`\.=1000\relax%
}

\NewDocumentCommand{\auth}{m}{%
  \textbf{#1}%
}

\NewDocumentCommand{\data}{mm}{%
  \vskip10mm%
  \hfill\makebox{75mm}{\small%
    \IfStrEq{#2}{**}{%
      \centering\itshape Документ №~--- \slshape #1.%
    }{
      \centering\itshape Документ №~--- \slshape #1,%
      \\\itshape Автор ~--- \slshape #2.%
    }
  }
}

\NewDocumentCommand{\datax}{mm}%
  \vskip10mm
  \hfill\parbox[t]{79mm}{\small
    \IfStrEq{#2}{**}{%
      \centerline{\itshape Номер документа:~\slshape#1.}%
    }{
      \centerline{\itshape Номер документа:~\slshape#1,\ }%
      \centerline{\itshape Авторы:~\slshape#2.}%
    }
  }

\AtBeginDocument{
  \def\refname{Литература}%
  \baselineskip 13.5pt plus .1pt%
}

\endinput
