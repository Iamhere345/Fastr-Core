# Menu Widgets

Menu widgets are gui pages that you can add to Fastr and will be included in the menu. By default, Fastr comes with commands, changelog, donation and download widgets.

## Creating Menu Widgets

### Loader
go to your installation and create a folder and name it the name you would like for your widget. inside this put the gui stuff you would like to have for your widget. please keep in mind that the space you have for you ui is {0.775,0},{1,0}. while building your ui, you may want to put it inside a frame of that size.

### Source
- go to Fastr_Client > Resources > Menu > Tabs, duplicate one of the text buttons and name it what you want your widget to be called and change the text property to che text to the name of your widget. 
- go to Fastr_Client > Resources > MenuResources and create a folder that has the same name as the text button you just made (case sensitive). 
- go to Fastr_Client > Resources > Menu > MainMenu and build you ui there. when you are done drag the ui you made to the folder you made in step 2