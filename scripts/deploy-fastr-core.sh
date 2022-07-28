git branch deploy
git checkout deploy

cd src/Server/
    rm -rf Resources 
    rm Core/Commands/*
cd ../Client
    rm Active/FlyScript.client.lua
cd Resources
    rm FlightControl.rbxmx
    rm Message.rbxmx
    rm Notification.rbxmx
    rm SmallMessage.rbxmx
cd ../../Remotes
    rm Fly.model.json
    rm ShowCountdown.model.json
    rm ShowNotification.model.json
    rm ShowSmallMessage.model.json
    rm ShowMessage.model.json

git commit -am "deploy"
git push -f fastr-core

git checkout main
git branch -d deploy