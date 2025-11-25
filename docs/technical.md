# Technical documentation

## Resumen
Arquitectura simple con:
- ALB en subredes públicas
- EC2 en subredes privadas detrás del ALB (ASG con Launch Template)
- RDS Multi-AZ, cifrado y backups
- S3 para artefactos/archivos estáticos

## Notas de seguridad
- RDS no es público.
- SSH está restringido por `admin_cidr` variable (establece tu IP/32).
- IAM aplica least privilege para EC2 -> S3.
- En producción: habilitar KMS gestionado, monitoreo avanzado, backups y políticas de acceso más restrictivas.
