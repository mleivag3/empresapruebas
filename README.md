# infra-terraform

Repositorio Terraform para desplegar una arquitectura básica en AWS.

Componentes:
- VPC: 2 subredes públicas, 2 privadas, tablas de ruta
- NAT Gateway + Internet Gateway
- ALB (Application Load Balancer)
- EC2 en subredes privadas detrás del ALB (Auto Scaling Group + Launch Template)
- RDS MySQL (Multi-AZ, encrypted, backups)
- S3 bucket para logs/archivos estáticos
- IAM roles con least-privilege (mejoradas)
- CloudWatch Dashboard (EC2 CPU, ALB latency, RDS connections)

IMPORTANTE:
- Copia `terraform/terraform.tfvars.example` a `terraform/terraform.tfvars` y ajusta valores antes de aplicar.
- Este despliegue crea recursos que pueden generar cargo en AWS (NAT Gateway, EC2, RDS).
 