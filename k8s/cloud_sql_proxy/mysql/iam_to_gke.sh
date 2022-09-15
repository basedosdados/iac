gcloud iam service-accounts add-iam-policy-binding \
                                       --role roles/iam.workloadIdentityUser \
                                       --member "serviceAccount:basedosdados-dev.svc.id.goog[cloud-sql-proxy-mysql/cloud-sql-access]" \
                                       gsa-cloudsql@basedosdados-dev.iam.gserviceaccount.com
