;;
;; OpenMAX ILC tts settings for the Raspberry Pi using Mike Ray's library.
;;
;;
;; Load with:
;; (load-library "omx-settings.el")

(defvar ilctts-destination "local"
"Currently selected OMX text-to-speech output")

;;
;; Select the analog audio jack
;;
(defun set-tts-local ()
	"select the analog audio jack"
	(interactive)
	(setq ilctts-destination "local"))

;;
;; Select the hdmi socket
;;
(defun set-tts-hdmi ()
"Select the hdmi digital video and audio jack"
(interactive)
(setq ilctts-destination "hdmi"))

