
;;;======================================================
;;;   PC components choose helper
;;;
;;;     This expert system helps user
;;;     to choose PC's components.
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



(defrule hddcapacity ""
   (not (capacity ?))
   =>
   (assert (capacity (yes-or-no-p "Будете ли использовать большое количество данных? (yes/no)? ")))) 
(defrule systemblock ""
   (not (block ?))
   =>
   (assert (block (yes-or-no-p "Нужен ли продвинутый корпус? (yes/no)? "))))
   (defrule videomonte ""
   (not (videomontazhe ?))
   =>
   (assert (videomontazhe (yes-or-no-p "Собираетесь ли вы на компьютере монтировать видео? (yes/no)? "))))
(defrule gamingpcorno ""
   (not (gamingpc ?))
   =>
   (assert (gamingpc (yes-or-no-p "Компьютер нужен для игр? (yes/no)? "))))   
;;;****************
;;;* CHOOSE RULES *
;;;****************

(defrule pcisforgamer ""
   (gamingpc no
   (videomontazhe ?)
   (block ?)
   (capacity ?)
   =>
   (assert (repair "Процессор: AMD Ryzen 5 1600, Материнская плата: AMD B450, Оперативная память: 8 Гбайт DDR4-3000/3200")))
   
(defrule pcisnotforgamer ""
   (gamingpc yes)
   (videomontazhe ?)
   (block ?)
   (capacity ?)
   =>
   (assert (repair "Процессор: Intel Core i9-9900K, Материнская плата: Intel Z390, Оперативная память: 32 Гбайт DDR4-3466/3600")))
(defrule videocardgood ""
   (videomontazhe yes)
   (gamingpc yes)
   (block ?)
   (capacity ?)
   =>
   (assert (repair "Видеокарта: NVIDIA GeForce RTX 2080 Ti, 11 Гбайт GDDR6"))) 
(defrule videocardgoodnotforgames ""
   (videomontazhe yes)
   (gamingpc no)
   (block ?)
   (capacity ?)
   =>
   (assert (repair "Видеокарта: NVIDIA TITAN RTX")))  
(defrule videocardbadforgames ""
   (videomontazhe no)
   (gamingpc yes)
   (block ?)
   (capacity ?)
   =>
   (assert (repair "Видеокарта: NVIDIA GeForce RTX 2070 Super, 8 Гбайт GDDR6")))  
(defrule videocardbadnotforforgames ""
   (videomontazhe no)
   (gamingpc no)
   (block ?)
   (capacity ?)
   =>
   (assert (repair "Видеокарта: AMD Radeon RX 570 8 Гбайт"))) 
(defrule capacityno ""
   (capacity no)
   (block ?)
   (block ?)
   (capacity ?)
   =>
   (assert (repair "Накопитель: SSD, 240-256 Гбайт, SATA 6 Гбит/с"))) 
(defrule capacitybig ""
   (capacity yes)
   (block ?)
   (block ?)
   (capacity ?)
   =>
   (assert (repair "Накопители: SSD, 1 Тбайт, PCI Express x4 3.0, HDD по вашему усмотрению"))) 
(defrule blockgood ""
   (block yes)
   (capacity ?)
   =>
   (assert (repair "Корпус: Phanteks Enthoo Evolv X Glass Galaxy Silver, Блок питания: Be Quiet Straight Power 11 Platinum, 750 Вт"))) 
(defrule blockbad ""
   (block no)
   (capacity ?)
   =>
   (assert (repair "Корпус: Zalman ZM-T6, Блок питания: Be Quiet System Power 9 500 Вт")))
   
;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 2))
  =>
  (println crlf "Экспертная система выбора комплектующего компьютера" crlf))

(defrule print-repair ""
  (declare (salience 2))
  (repair ?item)
  =>
  (println " " ?item crlf))
