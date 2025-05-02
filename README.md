otus-project

1. Создаем Service Account с правами: compute.admin, vpc.admin, k8s.admin, editor
2. Создаем секреты в GitHub: CLOUD_ID (yc resource-manager cloud list), FOLDER_ID (yc resource-manager folder list), SA_ID (yc iam service-account list), KEY (yc iam key create --service-account-name sa --output - | base64 -w 0)
3. Копируем репозиторий: git clone https://github.com/1uanv1/otus-project.git
4. Пушим в main
5. Адрес приложения и Графаны можно узнать в Git Actions.

