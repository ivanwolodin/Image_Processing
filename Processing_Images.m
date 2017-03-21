% *************************************************************** 
% FIRST GUI APPLICATION                                  ******
% Created for processing IAB Images                      ******
% Designed by Ivan Volodin                                   *******
% Version 2.0                                                       *******
% Release Date 27.02.2017                                  ********
%****************************************************************

function GUI
global texxt;
global stroka;
global TextNumber;
global photosNumber;
photosNumber=100-1;

figure('Name','Image for Processing IAB Images','Visible','On','NumberTitle','off',...
    'Position', [320,30,500,650],...
    'resize','off', ...
    'menubar','none')
 
 [x,map]=imread('image.png');
  I2=imresize(x, [274 325]);
  h=uicontrol('style','pushbutton',...
            'units','pixels',...
            'position',[53 147 113+274 85+275],...
            'cdata',I2,...
            'Enable', 'inactive')

uicontrol('Style', 'PushButton', ...
    'String', 'Process Images' ,'Position', [20,30,470,50],...,
     'fontsize',14,...
    'CallBack', @Processing_IAB_Images)

uicontrol('Style', 'PushButton', ...
    'String', 'Write Data to File' ,'Position', [20,90,470,50],...,
     'fontsize',14,...
    'CallBack', @Write_to_File)

uicontrol('Style', 'PushButton', ...
    'String', 'Set Dir' ,'Position', [20,615,120,30],...,
     'fontsize',12,...
    'CallBack', @Set_Dir)

stroka = uicontrol('Style', 'Edit', ...
    'String', 'Enter Directory using ctrl + v', ...
     'fontsize',12,...
    'HorizontalAlignment', 'center', ...
    'Position', [190,615,300,31])

texxt=uicontrol('Style', 'Text', ...
    'String', ' Current Dir', ...
     'fontsize',12,...
    'HorizontalAlignment', 'center', ...
'Position', [190,555,300,50])

uicontrol('Style', 'PushButton', ...
    'String', 'Get Dir' ,'Position', [20,555,120,50],...,
     'fontsize',12,...
    'CallBack', @Get_Dir)

TextNumber= uicontrol('Style', 'Edit', ...
    'String', ' Set amount of photos', ...
     'fontsize',12,...
    'HorizontalAlignment', 'center', ...
'Position', [190,515,300,30])

uicontrol('Style', 'PushButton', ...
    'String', 'Set Number' ,'Position', [20,515,120,30],...,
     'fontsize',12,...
    'CallBack', @Get_number)

function Get_number(qqq,eee)
global photosNumber;
global TextNumber;
photosNumber=get(TextNumber,'string');
%photosNumber=strr-'0';
%photosNumber=str2double('strr');


function Get_Dir(ff,gg)
global texxt;
global stroka;
% ss=get(stroka, 'string');
ss=pwd; % pwd - получить текущую директорию
set(texxt, 'String', ss);
%   end

function Set_Dir(fff,ggg)
global texxt;
global stroka;
ss=get(stroka, 'string');
cd(ss);
% end

function Processing_IAB_Images(h,t)
global South_North;
global West_East;
global Avarage_South_North;
global Avarage_West_East;
global photosNumber;
sto=str2num(photosNumber)-1;
% ---------------------------------------------------
% Анализ изображений IAB
% by I.V.
% date: 21.02.2017
% ---------------------------------------------------
South_North=zeros(1,100);
West_East=zeros(1,100);

counter=1;
global stroka;
ss=get(stroka, 'string');
cd(ss);
% поменять директорию
% ----------------------------------------------------------------------------
%cd(newFolder)
%oldFolder = cd(newFolder)
%cd
%cd('C:\Users\Иван\centre_filtred');
% ----------------------------------------------------------------------------
i=1;
for i=1:sto;
     
    %ss='C:\Users\Иван\Desktop\IAB turb\Anya_Vanya\centre_filtred';
    
    ss=strcat( num2str(i),'.jpg');
    eval('A=imread(ss);');
    %I=imread('C:\Users\Иван\Desktop\IAB turb\10 photos\4.jpg'); % считываем файл, каждый пиксель кодируется интенсивностью (от 0 до 255)
    [X,Y]=meshgrid(1:312,1:248); % делаем сетку координат, подготавливаем два массива, для координаты по Х и по У. ДЛя навигации, чтобы знать значение точек
    
    %  считываем файл в таком виде. Цифра отвечает за яркость пикселя
    %
    %   00000000000000000000000
    %   00 3                       5       0
    %   00      255               5       0
    %   00  7                      23    00
    %   00    7     8         44          0
    %   00             98  123           0
    %   00000000000000000000000
    %
    
    % если координата больше 254 -----> жидкость нагретая. логический массив.
    % 1/0
    XX=X(A>254); % находим все координаты точек матрицы Х, у которых значение больше 254
    YY=Y(A>254); % находим все координаты точек матрицы У, у которых значения больше 254
    
    % нашли значение максимальных и минимальных элементов
    maxX=max(XX);
    maxY=max(YY);
    minY=min(YY);
    minX=min(XX);
    
    % нашли индексы
    NmaxX=find(max(YY)==YY);
    NminX=find(min(YY)==YY);
    
    %R=sqrt( ( max(XX(NmaxX))-min(XX(NminX)) )^2 + (maxY-minY)^2 ); % расстояние между крайними точками
    Distance_south_north = maxY-minY;
    Distance_west_east = maxX-minX;
    South_North(counter)=Distance_south_north;
    West_East(counter)=Distance_west_east;
    counter=counter+1;
end;

% вычисление среднего
% --------------------------------------------------------------------------------------
Avarage_South_North=zeros(1,sto);
Avarage_West_East=zeros(1,sto);
for i=1:1:sto;
    R=0;
    V=0;
    for j=1:1:i+1;
        R=R+South_North(j);
        V=V+West_East(j);
    end
    Avarage_South_North(i)=R/(i+1);
    Avarage_West_East(i)=V/(i+1);
end
% --------------------------------------------------------------------------------------

%mean value
meanSN=mean (South_North);
meanEW = mean(West_East);
l=1:1:sto;
% вывод результатов
% ---------------------------------------------------------------------------------------
figure('Name','South_North','NumberTitle','off')
plot( Avarage_South_North);
legend (['Мат. ожидание = ' num2str(meanSN)],'Location','southeast','Orientation','horizontal')
title('Avarage South North');
ylim([0 189]);
ylabel('south north');
xlabel('number ');
 
grid on;
hold on;

figure('Name','East_West','NumberTitle','off')
plot( Avarage_West_East);

legend (['Мат. ожидание = ' num2str(meanEW)],'Location','southeast','Orientation','horizontal')
title('Avarage West East');
ylabel('west east');
ylim([0 175]);
xlabel('number ');
grid on;
hold on;
% ---------------------------------------------------------------------------------------
%   end

%end % конец главной функции

function Write_to_File(qq,we)
global South_North;
global West_East;
global Avarage_South_North;
global Avarage_West_East;
header1 = 'South';
header2 = ' North';
fid=fopen('Result.txt','w');
fprintf(fid,['*************************\n']);
fprintf(fid, [ header1 ' ' header2 '\n']);
fprintf(fid,['*************************\n']);
fprintf(fid, '%i \n', [South_North]);
fprintf(fid, ['\n']);
header3 = 'East';
header4 = 'West';
fprintf(fid,['*************************\n']);
fprintf(fid, [ header3 ' ' header4 '\n']);
fprintf(fid,['*************************\n']);
fprintf(fid, '%i \n', [West_East]);
fprintf(fid,['*************************\n']);
fprintf(fid, [ 'Average South_North \n']);
fprintf(fid,['*************************\n']);
fprintf(fid, '%f \n', [Avarage_South_North]);
fprintf(fid,['*************************\n']);
fprintf(fid, [ 'Average West_East \n']);
fprintf(fid,['*************************\n']);
fprintf(fid, '%f \n', [Avarage_West_East]);
fclose(fid);

 
