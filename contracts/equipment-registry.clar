;; Equipment Registration Contract
;; Records details of emergency communication gear

(define-data-var admin principal tx-sender)

;; Equipment data structure
(define-map equipments
  { equipment-id: (string-ascii 36) }
  {
    owner: principal,
    equipment-type: (string-ascii 50),
    capabilities: (string-ascii 255),
    location: (string-ascii 100),
    status: (string-ascii 20),
    last-maintenance: uint,
    registered-at: uint
  }
)

;; Public function to register new equipment
(define-public (register-equipment
    (equipment-id (string-ascii 36))
    (equipment-type (string-ascii 50))
    (capabilities (string-ascii 255))
    (location (string-ascii 100)))
  (let ((current-time (get-block-info? time (- block-height u1))))
    (if (is-some (map-get? equipments { equipment-id: equipment-id }))
      (err u1) ;; Equipment ID already exists
      (ok (map-insert equipments
        { equipment-id: equipment-id }
        {
          owner: tx-sender,
          equipment-type: equipment-type,
          capabilities: capabilities,
          location: location,
          status: "operational",
          last-maintenance: (default-to u0 current-time),
          registered-at: (default-to u0 current-time)
        }
      ))
    )
  )
)

;; Update equipment status
(define-public (update-equipment-status
    (equipment-id (string-ascii 36))
    (new-status (string-ascii 20)))
  (let ((equipment (map-get? equipments { equipment-id: equipment-id })))
    (if (is-none equipment)
      (err u2) ;; Equipment not found
      (if (is-eq tx-sender (get owner (unwrap-panic equipment)))
        (ok (map-set equipments
          { equipment-id: equipment-id }
          (merge (unwrap-panic equipment) { status: new-status })
        ))
        (err u3) ;; Not the owner
      )
    )
  )
)

;; Update equipment location
(define-public (update-equipment-location
    (equipment-id (string-ascii 36))
    (new-location (string-ascii 100)))
  (let ((equipment (map-get? equipments { equipment-id: equipment-id })))
    (if (is-none equipment)
      (err u2) ;; Equipment not found
      (if (is-eq tx-sender (get owner (unwrap-panic equipment)))
        (ok (map-set equipments
          { equipment-id: equipment-id }
          (merge (unwrap-panic equipment) { location: new-location })
        ))
        (err u3) ;; Not the owner
      )
    )
  )
)

;; Record equipment maintenance
(define-public (record-maintenance
    (equipment-id (string-ascii 36)))
  (let ((equipment (map-get? equipments { equipment-id: equipment-id }))
        (current-time (get-block-info? time (- block-height u1))))
    (if (is-none equipment)
      (err u2) ;; Equipment not found
      (if (is-eq tx-sender (get owner (unwrap-panic equipment)))
        (ok (map-set equipments
          { equipment-id: equipment-id }
          (merge (unwrap-panic equipment) { last-maintenance: (default-to u0 current-time) })
        ))
        (err u3) ;; Not the owner
      )
    )
  )
)

;; Read-only function to get equipment details
(define-read-only (get-equipment (equipment-id (string-ascii 36)))
  (map-get? equipments { equipment-id: equipment-id })
)

