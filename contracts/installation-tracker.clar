;; Installation Tracker Contract
;; Tracks professional installations and certifications

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u300))
(define-constant ERR-INSTALLATION-NOT-FOUND (err u301))
(define-constant ERR-INSTALLER-NOT-CERTIFIED (err u302))
(define-constant ERR-INVALID-INPUT (err u303))
(define-constant ERR-INSTALLATION-ALREADY-EXISTS (err u304))

;; Data Variables
(define-data-var next-installation-id uint u1)

;; Data Maps
(define-map installations
  { installation-id: uint }
  {
    part-id: uint,
    installer: principal,
    vehicle-owner: principal,
    vehicle-vin: (string-ascii 17),
    installation-date: uint,
    quality-score: uint,
    warranty-activated: bool,
    notes: (string-ascii 200)
  }
)

(define-map certified-installers
  { installer: principal }
  {
    name: (string-ascii 100),
    certification-level: uint,
    certification-date: uint,
    is-active: bool,
    specializations: (list 5 (string-ascii 30))
  }
)

(define-map installation-quality
  { installation-id: uint }
  {
    inspection-date: uint,
    inspector: principal,
    quality-rating: uint,
    defects-found: (list 10 (string-ascii 50)),
    corrective-actions: (string-ascii 200)
  }
)

;; Authorization Functions
(define-private (is-contract-owner)
  (is-eq tx-sender CONTRACT-OWNER)
)

(define-private (is-certified-installer (installer principal))
  (match (map-get? certified-installers { installer: installer })
    installer-data (get is-active installer-data)
    false
  )
)

;; Installer Management
(define-public (certify-installer
  (installer principal)
  (name (string-ascii 100))
  (certification-level uint)
  (specializations (list 5 (string-ascii 30)))
)
  (begin
    (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
    (asserts! (> (len name) u0) ERR-INVALID-INPUT)
    (asserts! (and (>= certification-level u1) (<= certification-level u5)) ERR-INVALID-INPUT)

    (ok (map-set certified-installers
      { installer: installer }
      {
        name: name,
        certification-level: certification-level,
        certification-date: block-height,
        is-active: true,
        specializations: specializations
      }
    ))
  )
)

(define-public (update-installer-status (installer principal) (is-active bool))
  (begin
    (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
    (match (map-get? certified-installers { installer: installer })
      installer-data
        (ok (map-set certified-installers
          { installer: installer }
          (merge installer-data { is-active: is-active })
        ))
      ERR-INSTALLER-NOT-CERTIFIED
    )
  )
)

;; Installation Management
(define-public (record-installation
  (part-id uint)
  (vehicle-owner principal)
  (vehicle-vin (string-ascii 17))
  (quality-score uint)
  (notes (string-ascii 200))
)
  (let ((installation-id (var-get next-installation-id)))
    (asserts! (is-certified-installer tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (and (>= quality-score u1) (<= quality-score u10)) ERR-INVALID-INPUT)
    (asserts! (is-eq (len vehicle-vin) u17) ERR-INVALID-INPUT)

    (map-set installations
      { installation-id: installation-id }
      {
        part-id: part-id,
        installer: tx-sender,
        vehicle-owner: vehicle-owner,
        vehicle-vin: vehicle-vin,
        installation-date: block-height,
        quality-score: quality-score,
        warranty-activated: false,
        notes: notes
      }
    )

    (var-set next-installation-id (+ installation-id u1))
    (ok installation-id)
  )
)

(define-public (activate-installation-warranty (installation-id uint))
  (let ((installation-data (unwrap! (map-get? installations { installation-id: installation-id }) ERR-INSTALLATION-NOT-FOUND)))
    (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)

    (ok (map-set installations
      { installation-id: installation-id }
      (merge installation-data { warranty-activated: true })
    ))
  )
)

;; Quality Management
(define-public (record-quality-inspection
  (installation-id uint)
  (quality-rating uint)
  (defects-found (list 10 (string-ascii 50)))
  (corrective-actions (string-ascii 200))
)
  (let ((installation-data (unwrap! (map-get? installations { installation-id: installation-id }) ERR-INSTALLATION-NOT-FOUND)))
    (asserts! (is-contract-owner) ERR-NOT-AUTHORIZED)
    (asserts! (and (>= quality-rating u1) (<= quality-rating u10)) ERR-INVALID-INPUT)

    (ok (map-set installation-quality
      { installation-id: installation-id }
      {
        inspection-date: block-height,
        inspector: tx-sender,
        quality-rating: quality-rating,
        defects-found: defects-found,
        corrective-actions: corrective-actions
      }
    ))
  )
)

;; Read-only Functions
(define-read-only (get-installation (installation-id uint))
  (map-get? installations { installation-id: installation-id })
)

(define-read-only (get-installer (installer principal))
  (map-get? certified-installers { installer: installer })
)

(define-read-only (get-installation-quality (installation-id uint))
  (map-get? installation-quality { installation-id: installation-id })
)

(define-read-only (is-installation-warranty-eligible (installation-id uint))
  (match (map-get? installations { installation-id: installation-id })
    installation-data
      (and
        (is-certified-installer (get installer installation-data))
        (>= (get quality-score installation-data) u7)
        (not (get warranty-activated installation-data))
      )
    false
  )
)

(define-read-only (get-installer-certification-level (installer principal))
  (match (map-get? certified-installers { installer: installer })
    installer-data (some (get certification-level installer-data))
    none
  )
)

(define-read-only (get-next-installation-id)
  (var-get next-installation-id)
)
