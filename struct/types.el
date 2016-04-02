;;; This file defines the base data type hierarchy for structure
;;; types.  It includes primitive types (and common Qt types).

(defclass data-type ()
  ((comment :initarg :comment :initform ""))
  "Base class for data types")

(defclass object-type (data-type)
  ()
  "Base class for non-primitive types")

(defmethod parameter-type ((n object-type))
  (format "const %s&" (cpp-name n)))

(defmethod primitive-p ((n object-type))
  nil)

(defclass user-type (object-type)
  ()
  "Base class for user types")

(defclass primitive-type (data-type)
  ()
  "Base class for primitives")

(defmethod parameter-type ((n primitive-type))
  (cpp-name n))

(defmethod primitive-p ((n primitive-type))
  t)

(defmacro define-cpp-primitive (type def)
  `(progn
     (defclass ,type (primitive-type)
       ())

     (defmethod cpp-name ((n ,type))
       ,(symbol-name type))

     (defmethod primitive-default-value ((n ,type))
       ,def)

     ',type))

(define-cpp-primitive bool "false")
(define-cpp-primitive char "'\\0'")
(define-cpp-primitive short "0")
(define-cpp-primitive int "0")
(define-cpp-primitive long "0")
(define-cpp-primitive double "NaN")
(defclass cfloat (primitive-type)
  ())

(defmethod cpp-name ((n cfloat))
  "float")

(defmethod primitive-default-value ((n cfloat))
  "NaNf")

(define-cpp-primitive qint8 "0")
(define-cpp-primitive quint8 "0")
(define-cpp-primitive qint16 "0")
(define-cpp-primitive quint16 "0")
(define-cpp-primitive qint32 "0")
(define-cpp-primitive quint32 "0")
(define-cpp-primitive qint64 "0")
(define-cpp-primitive quint64 "0")

(define-cpp-primitive void* "nullptr")
(define-cpp-primitive qreadwritelock* "nullptr")

(defmacro define-object (type class)
  `(progn
     (defclass ,type (object-type)
       ())

     (defmethod cpp-name ((n ,type))
       ,class)

     ,type))

(define-object string "QString")
(define-object date "QDate")
(define-object datetime "QDateTime")
(define-object qimage "QImage")
(define-object qsize "QSize")
(define-object qsizef "QSizeF")
(define-object qvector2d "QVector2D")
(define-object qvector3d "QVector3D")

(defclass qlist (object-type)
  ((value-type :initarg :of)))

(defun make-instance-from-slot (s)
  (if (listp s)
      (apply #'make-instance s)
    (make-instance s)))

(defmethod cpp-name ((n qlist))
  (let ((value-class (make-instance-from-slot (slot-value n 'value-type))))
    (format "QList<%s>" (cpp-name value-class))))

(defclass qvector (object-type)
  ((value-type :initarg :of)))

(defmethod cpp-name ((n qvector))
  (let ((value-class (make-instance-from-slot (slot-value n 'value-type))))
    (format "QVector<%s>" (cpp-name value-class))))

(defclass qmap (object-type)
  ((key-type :initarg :from)
   (value-type :initarg :to)))

(defmethod cpp-name ((n qmap))
  (let ((key-class (make-instance-from-slot (slot-value n 'key-type)))
        (value-class (make-instance-from-slot (slot-value n 'value-type))))
    (format "QMap<%s, %s>" (cpp-name key-class) (cpp-name value-class))))

(defclass qimage-format (primitive-type)
  ())

(defmethod cpp-name ((n qimage-format))
  "QImage::Format")

(defmethod primitive-default-value ((n qimage-format))
  "QImage::Format_Invalid")
