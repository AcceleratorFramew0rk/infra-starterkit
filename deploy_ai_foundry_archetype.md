# AI Foundry Archetype

## 1. Launchpad

```bash
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration

cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad

./scripts/import.sh

```

## 2. Infra and Application Landing zone

```bash

tfexe apply -include=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/AI_Foundry_LZ.hcl

```

### 3. Solution Accelerators

```bash

tfexe apply -include=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/AI_Foundry_pattern.hcl

```

