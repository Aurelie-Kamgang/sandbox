# k3s Terraform AWS Cluster

Ce projet permet de déployer un cluster Kubernetes k3s sur AWS via Terraform :  
- 1 master, N agents
- Réseau et sécurité dédiés
- Installation et join automatique

## Prérequis
- Terraform >= 1.0
- Credentials AWS
- Une AMI Ubuntu Server récente (pour `ami_id` dans `variables.tf`)

## Utilisation

1. Copie tous les fichiers dans un dossier
2. Modifie `variables.tf` pour l'AMI Ubuntu de ta région
3. Initialise Terraform :
   ```
   terraform init
   ```
4. Visualise le plan :
   ```
   terraform plan
   ```
5. Déploie :
   ```
   terraform apply
   ```
6. Récupère l'IP publique du master (`k3s_master_public_ip`) et SSH dessus pour vérifier le cluster :
   ```
   kubectl get nodes
   ```

## Sécurité
- Les agents se connectent au master via SSH pour récupérer le token (nécessite que l'IP SSH soit accessible).
- Pour la prod, ajoute une gestion fine des clés SSH et des security groups.

## Personnalisation
- Modifie `agent_count` pour le nombre de nœuds.
- Change le type d'instance si besoin.