;;
;; OpenMAX ILC tts settings for the Raspberry Pi using Mike Ray's library.
;;
;;
;; Load with:
;; (load-library "omx-settings.el")

(defvar ilctts-destination "local"
(_"Currently selected OMX text-to-speech output"))

;;
;; Select the analog audio jack
;;
(defun set-tts-local ()
	(_"select the analog audio jack")
	(interactive)
	(setq ilctts-destination "local"))

;;
;; Select the hdmi socket
;;
(defun set-tts-hdmi ()
 (_"Select the hdmi digital video and audio jack")
(interactive)
(setq ilctts-destination "hdmi"))

