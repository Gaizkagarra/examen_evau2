    New-LocalUser -Name "usu1examen" -Password (ConvertTo-SecureString "Password0" -AsPlainText -Force) -FullName "usu1examen" -Description "Usuario creado"
    New-LocalUser -Name "usu2examen" -Password (ConvertTo-SecureString "Password0" -AsPlainText -Force) -FullName "usu2examen" -Description "Usuario creado"


    New-Item -Path "C:\Users\usu1examen" -ItemType Directory
    New-Item -Path "C:\Users\usu2examen" -ItemType Directory

    
    Set-LocalUser -Name "usu1examen" -AccountNeverExpires
    Set-LocalUser -Name "usu2examen" -AccountNeverExpires
