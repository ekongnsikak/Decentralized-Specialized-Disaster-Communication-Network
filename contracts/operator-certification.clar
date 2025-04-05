;; Operator Certification Contract
;; Validates training in emergency protocols

(define-data-var admin principal tx-sender)

;; Certification data structure
(define-map certifications
  { operator: principal }
  {
    certification-level: uint,
    specializations: (list 10 (string-ascii 50)),
    issued-at: uint,
    expires-at: uint,
    is-active: bool,
    issuer: principal
  }
)

;; Certification authorities
(define-map certification-authorities
  { authority: principal }
  { authorized: bool }
)

;; Initialize admin as first certification authority
(map-insert certification-authorities
  { authority: tx-sender }
  { authorized: true }
)

;; Add a certification authority
(define-public (add-certification-authority (authority principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1)) ;; Only admin can add authorities
    (ok (map-insert certification-authorities
      { authority: authority }
      { authorized: true }
    ))
  )
)

;; Issue certification to an operator
(define-public (issue-certification
    (operator principal)
    (certification-level uint)
    (specializations (list 10 (string-ascii 50)))
    (valid-for-days uint))
  (let ((authority-status (map-get? certification-authorities { authority: tx-sender }))
        (current-time (get-block-info? time (- block-height u1)))
        (expiration-time (+ (default-to u0 current-time) (* valid-for-days u86400))))
    (asserts! (and (is-some authority-status) (get authorized (unwrap-panic authority-status))) (err u2)) ;; Not authorized
    (ok (map-set certifications
      { operator: operator }
      {
        certification-level: certification-level,
        specializations: specializations,
        issued-at: (default-to u0 current-time),
        expires-at: expiration-time,
        is-active: true,
        issuer: tx-sender
      }
    ))
  )
)

;; Revoke certification
(define-public (revoke-certification (operator principal))
  (let ((certification (map-get? certifications { operator: operator }))
        (authority-status (map-get? certification-authorities { authority: tx-sender })))
    (asserts! (and (is-some authority-status) (get authorized (unwrap-panic authority-status))) (err u2)) ;; Not authorized
    (if (is-none certification)
      (err u3) ;; Certification not found
      (ok (map-set certifications
        { operator: operator }
        (merge (unwrap-panic certification) { is-active: false })
      ))
    )
  )
)

;; Check if operator is certified
(define-read-only (is-certified (operator principal))
  (let ((certification (map-get? certifications { operator: operator }))
        (current-time (get-block-info? time (- block-height u1))))
    (if (is-none certification)
      false
      (and
        (get is-active (unwrap-panic certification))
        (< (default-to u0 current-time) (get expires-at (unwrap-panic certification)))
      )
    )
  )
)

;; Get operator certification details
(define-read-only (get-certification (operator principal))
  (map-get? certifications { operator: operator })
)

