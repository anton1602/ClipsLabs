
;;;======================================================
;;;   Record player Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems record player.
;;;
;;;     CLIPS Version 6.4 Example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (print ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer ?allowed-values)) do
      (print ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule headcleaning ""
   (not (headclean ?))
   =>
   (assert (headclean(yes-or-no-p "Головка чистая (yes/no)? "))))
   
(defrule casettenorman ""
   (headclean yes)
   =>
   (assert (cassette (yes-or-no-p "Касета установлена правильно (yes/no)? "))))

;;;****************
;;;* REPAIR RULES *
;;;****************

(defrule headtapebad ""
   (headclean no)
   =>
   (assert (repair "Почитстите головку.")))

(defrule cassetteproblem ""
   (cassette no)
   =>
   (assert (repair "Установите касету правильно."))) 
   
(defrule problemisnotconcluded ""
   (cassette yes)
   (headclean yes)
   =>
   (assert (repair "Обратитесь к мастеру."))) 

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 2))
  =>
  (println crlf "Экспертная система диагностики неисправности магнитофона" crlf))

(defrule print-repair ""
  (declare (salience 2))
  (repair ?item)
  =>
  (println crlf "Предложенное решение:" crlf)
  (println " " ?item crlf))
