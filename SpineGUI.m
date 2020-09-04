function varargout = SpineGUI(varargin)
% SPINEGUI MATLAB code for SpineGUI.fig
%      SPINEGUI, by itself, creates a new SPINEGUI or raises the existing
%      singleton*.
%
%      H = SPINEGUI returns the handle to a new SPINEGUI or the handle to
%      the existing singleton*.
%
%      SPINEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPINEGUI.M with the given input arguments.
%
%      SPINEGUI('Property','Value',...) creates a new SPINEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpineGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpineGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpineGUI

% Last Modified by GUIDE v2.5 25-May-2018 15:01:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SpineGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SpineGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


% End initialization code - DO NOT EDIT
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Initial Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


%{ 
    This program was written for analysis of the lumbar discs and vertebrae MR Images

    by Vahid Abdollah MSc PhD

    Department of Physical Therapy, Faculty of Rehabilitation Medicine

    University of Alberta, Edmonton, AB, CA T6G 2G4

    email: v.abdollah@ualberta.ca    

    All Rights Reserved. 

    No part of this program may be reproduced, modified or adapted 

    WITHOUT THE PRIOR WRITTEN CONSENT OF THE AUTHOR.

    Copyright 2013-2020

%}


% --- Executes just before SpineGUI is made visible.
function SpineGUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

clc

handles.output = hObject;

guidata(hObject, handles);

movegui(gcf, 'center')

warning('off', 'all');

addpath('Support');

UofALogo=imread('Logo.jpg');

axes(handles.axes2);

imshow(UofALogo);

mkdir([pwd, '\Archive\']);

mkdir([pwd, '\Results\']);

mkdir([pwd, '\Images\', 'Have not been analyzed']);


% --- Outputs from this function are returned to the command line.
function varargout = SpineGUI_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on button press in agree (pushbutton1).
function pushbutton1_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>

set(handles.uipanel9, 'visible', 'off');

set(handles.uipanel13, 'visible', 'on');

GUILogo = imread('GUI Logo.jpg');

axes(handles.axes6);

imshow(GUILogo);

evalin('base', 'clearvars -except img DIIinfo PathName SubjectID xul* yul* xdl* ydl* xl* yl* xs1 ys1')

eimg = evalin('base', 'exist(''img'')');

eDIIinfo = evalin('base', 'exist(''DIIinfo'')');

ePathName = evalin('base', 'exist(''PathName'')');

eFileName = evalin('base', 'exist(''SubjectID'')');

if eimg == 1 && eDIIinfo == 1 && ePathName == 1 && eFileName == 1
    
    set([handles.text9, handles.pushbutton49, handles.pushbutton50], 'visible', 'on')
    
else
    
    set([handles.text4, handles.pushbutton3, handles.pushbutton4], 'visible', 'on')
    
end


% --- Executes on button press in discagree(pushbutton2).
function pushbutton2_Callback(hObject, eventdata, handles)

global SubjectID

waitfor(errordlg('You did not agree with our license agreement.!', 'MR Image Processing GUI'));

if SubjectID == 0
    
    return
    
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Analyzing an old image
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in analyzing old image (pushbutton50).
function pushbutton50_Callback(hObject, eventdata, handles)

global SubjectID

set([handles.text9, handles.pushbutton49, handles.pushbutton50], 'visible', 'off')

img = evalin('base','img');

axes(handles.axes6);

imshow(img,[]);

try 
    
    load([pwd, '\Archive\', SubjectID, '\Levels']);
    
    Naming_Vertebrae_Fcn(hObject, eventdata, handles)
    
    Set_Selection_Handels_On_Fcn (hObject, eventdata, handles)
    
    set(gca, 'XLim', [xl3 - 100, xl4 + 100], 'YLim', [yl1 - 100, ys1 + 100]);
    
    set([handles.text4, handles.pushbutton3, handles.pushbutton4], 'visible', 'off')
    
catch me
    
    Label_Discs_Level(hObject, eventdata, handles)
    
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Analyzing a New Image
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in analyzing new image (pushbutton49).
function pushbutton49_Callback(hObject, eventdata, handles)

evalin('base', 'clear variables');

set([handles.text9, handles.pushbutton49, handles.pushbutton50], 'visible', 'off')

set([handles.text4, handles.pushbutton3, handles.pushbutton4], 'visible', 'on')


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Single-echo Images
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in single echo image (pushbutton3).
function pushbutton3_Callback(hObject, eventdata, handles)

global SubjectID SubID DIIinfo Joubin

clc

Joubin = 2;

[SubjectID, PathName] = uigetfile({'*.*', 'All Files'}, 'Please select the DICOM image that you want to analyze!');

assignin('base', 'SubjectID', SubjectID)

assignin('base', 'PathName', PathName)

if SubjectID == 0
    
    return

end

copyfile([PathName, '\', SubjectID], [pwd, '\Images\Have not been analyzed\UL1']);

img = dicomread([pwd, '\Images\Have not been analyzed\', SubjectID]);

axes(handles.axes6);

imshow(img, []);

assignin('base', 'img', img)

DIIinfo = dicominfo([pwd,'\Images\Have not been analyzed\',SubjectID]);

assignin('base', 'DIIinfo', DIIinfo)

SubjectID = num2str(DIIinfo.PatientID);

assignin('base', 'SubjectID', SubjectID)

SubID = SubjectID(8:end);

SubID=strrep(SubID, 'KW', []);

assignin('base', 'SubID', SubID)

try 
    
    load([pwd, '\Archive\', SubjectID, '\Levels']);
    
    Naming_Vertebrae_Fcn(hObject, eventdata, handles)
    
    Set_Selection_Handels_On_Fcn (hObject, eventdata, handles)
    
    set(gca, 'XLim', [xl3 - 100, xl4 + 100], 'YLim', [yl1 - 100, ys1 + 100]);
    
    img = evalin('base', 'img');
    
    set([handles.text4, handles.pushbutton3, handles.pushbutton4], 'visible', 'off');
    
catch me
    
    Label_Discs_Level(hObject, eventdata, handles)
    
end

mkdir([pwd, '\Archive\', SubjectID]);


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Multi-echo Images
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in multi-echo image (pushbutton4).
function pushbutton4_Callback(hObject, eventdata, handles)

global SubjectID SubID DIIinfo Joubin

Joubin = 1;

[FileNameN, PathName] = uigetfile('*.*', 'Please Select the Dicomdir File for the Subject of Interest.');

assignin('base', 'FileName', FileNameN);

assignin('base', 'PathName', PathName)

if FileNameN == 0
    
    return

end

fid = fopen([PathName FileNameN]);

filecontent = fread(fid, inf);

scantitles = strfind(char(filecontent)', 'T2W_TSE_5echo'); % Finding desired scans 

str2 = [73 83 4 0]; %the prefix to the scan number

scantitles2 = zeros(size(scantitles));

for n = 1:numel(scantitles)
    
    teststring = strfind(char(filecontent(scantitles(n) : (scantitles(n) + 100)))', str2);
    
    if ~isempty(teststring)
        
        scantitles2(n) = 1;
    
    end %#ok<*STREMP>
    
end

scantitles = scantitles(logical(scantitles2)); %filter out any repeated scan names

scannums = zeros(1, numel(scantitles));

firstimnums = zeros(1, numel(scantitles));

for n = 1:numel(scannums)
    
	scannumloc = strfind(char(filecontent(scantitles(n):(scantitles(n)+100)))', str2);
    
    scannumloc = scannumloc + scantitles(n) - 1 + length(str2);
    
    scannum = filecontent(scannumloc:(scannumloc+3));
    
    suffixloc = strfind(char(scannum)', '01');
    
    scannums(n) = str2double(char(scannum(1:(suffixloc - 1)))');
    
    firstimlocs = strfind(char(filecontent(scantitles(n):(scantitles(n)+5000)))', 'IM_');
    
    firstimloc = firstimlocs(1) + scantitles(n) - 1;
    
    firstimnums(n) = str2double(char(filecontent(firstimloc + (3:6)))');
    
end

S = mat2cell(scannums, 1, ones(size(scannums))); %#ok<MMTC>

% Determining the number of echos in each image stacks
for n = 1:numel(scannums)
    
    S{n} = ['Scan ' num2str(S{n})];

end

[selection, outflag]=listdlg('PromptString', 'Select A Loading Condition:', 'SelectionMode', 'single', 'ListString', S);

if outflag == 0
    
    return

end

for n = 1:numel(firstimlocs) + 1
    
    if n == 1
        
        im1 = double(dicomread([PathName 'DICOM\IM_' sprintf('%04d', firstimnums(selection))]));
        
        ims = zeros([size(im1) numel(firstimlocs)]); 
        
        ims(:, :, 1) = im1;
        
        TE = zeros(1, numel(firstimlocs) - 1);
        
    else
        
        ims(:, :, n) = double(dicomread([PathName 'DICOM\IM_' sprintf('%04d', firstimnums(selection) + n - 1)]));
        
    end
    
    DIIinfo = dicominfo([PathName 'DICOM\IM_' sprintf('%04d', firstimnums(selection) + n - 1)]);
    
    if n == 1
        
        filename1 = DIIinfo.Filename;
        
    elseif n == 2
        
        filename2 = DIIinfo.Filename;
        
    elseif n == 3
        
        filename3 = DIIinfo.Filename;
        
    elseif n == 4
        
        filename4 = DIIinfo.Filename;
        
    elseif n == 5
        
        filename5 = DIIinfo.Filename;
        
    end
    
    TE(n) = DIIinfo.EchoTime;
    
end

TE = TE(1:end); %The last value was from the T2 map image, not an echo

me = ims(:, :, 1:end);

copyfile(filename1, [pwd, '\Images\Have not been analyzed\UL1'])

copyfile(filename2, [pwd, '\Images\Have not been analyzed\UL2'])

copyfile(filename3, [pwd, '\Images\Have not been analyzed\UL3'])

copyfile(filename4, [pwd, '\Images\Have not been analyzed\UL4'])

copyfile(filename5, [pwd, '\Images\Have not been analyzed\UL5'])

img = dicomread([pwd, '\Images\Have not been analyzed\UL3']);

imshow(img, [])

assignin('base', 'img', img)

DIIinfo = dicominfo([pwd, '\Images\Have not been analyzed\UL3']);

assignin('base', 'DIIinfo', DIIinfo)

SubjectID = num2str(DIIinfo.PatientID);

assignin('base', 'SubjectID', SubjectID)

SubID = SubjectID(8:end);

SubID = strrep(SubID, 'KW', []);

assignin('base', 'SubID', SubID)

try 
    
    load([pwd, '\Archive\', SubjectID, '\Levels']);
    
    Naming_Vertebrae_Fcn(hObject, eventdata, handles);
    
    Set_Selection_Handels_On_Fcn (hObject, eventdata, handles)
    
    set(gca, 'XLim', [xl3 - 100, xl4 + 100], 'YLim', [yl1 - 100, ys1 + 100]);
    
    img = evalin('base', 'img');
    
    set([handles.text4, handles.pushbutton3, handles.pushbutton4], 'visible', 'off');
    
catch me
    
    Label_Discs_Level(hObject, eventdata, handles)
    
end

mkdir([pwd, '\Archive\', SubjectID]);


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Zoom In & Out Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in zoom in (pushbutton6).
function pushbutton6_Callback(hObject, eventdata, handles)

clc

selection = getrect(handles.axes1);

img = evalin('base','img');

set(gca, 'XLim', [selection(1, 1), selection(1, 3) + selection(1, 1)], 'YLim', [selection(1, 2), selection(1, 4) + selection(1, 2)]);

guidata(hObject, handles);

img; %#ok<*VUNUS>


% --- Executes on button press in zoom out (pushbutton5).
function pushbutton5_Callback(hObject, eventdata, handles)

clc

exmax = evalin('base', 'exist(''xmax'')');

if exmax == 1
    
    img = evalin('base', 'img');
    
    set(gca, 'XLim', [evalin('base', 'xmin'), evalin('base', 'xmax')], 'YLim', [evalin('base', 'ymin'), evalin('base', 'ymax')]);
    
    guidata(hObject, handles);
    
else
    
    img = evalin('base', 'img');
    
    imshow(img,[]);
    
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Level selection Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function Label_Discs_Level(hObject, eventdata, handles)

global SubjectID DIIinfo xs1 ys1 xl5 yl5 xl4 yl4 xl3 yl3 xl2 yl2 xl1 yl1 xt12 yt12 s1 l5 l4 l3 l2 l1 t12

set([handles.text6,handles.edit1],'visible','on')

set([handles.text4,handles.pushbutton3,handles.pushbutton4],'visible','off')

SubID=SubjectID(8:end);

SubID=strrep(SubID,', KW',[]);

set(handles.edit1,'String',num2str(evalin('base','SubID')))

mt=num2str(DIIinfo.Manufacturer);

mkdir([pwd,'\Archive\',SubjectID]);

if strcmp(mt,'Philips Medical Systems')
    
    cr=char(round(DIIinfo.ReconstructionDiameter))/char(round(DIIinfo.Width));
    
elseif strcmp(mt,'SIEMENS')
    
    cr=0.5;
    
else
    
    waitfor(warndlg('I couldn''t recognized the MRI scanner! I set pixel-millimeter ratio at 1.','MR Image Processing'));
    
    cr=1;
    
end

for i=1:50
    
    if i==1
        
        waitfor(msgbox('Please label S1 through T12 vertebra!','EIC Image Analyzer'));
        
    end  
    
    [xs1,ys1]=ginput(1);
    
    s1=text(xs1,ys1,'S1','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle'); 
    
    [xl5,yl5]=ginput(1);
    
    l5=text(xl5,yl5,'L5','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle'); 
    
    [xl4,yl4]=ginput(1);
    
    l4=text(xl4,yl4,'L4','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle');
    
    [xl3,yl3]=ginput(1);
    
    l3=text(xl3,yl3,'L3','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle'); 
    
    [xl2,yl2]=ginput(1);
    
    l2=text(xl2,yl2,'L2','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle'); 
    
    [xl1,yl1]=ginput(1);
    
    l1=text(xl1,yl1,'L1','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle'); 
    
    [xt12,yt12]=ginput(1);
    
    t12=text(xt12,yt12,'T12','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle'); 
    
    choice=questdlg('Would you like to re-label S1 through T12 vertebra?','EIC Image Analyzer','Yes','No','No');
    
    switch choice
        
        case 'Yes'
            
            clearvars xs1 ys1 xl5 yl5 xl4 yl4 xl3 yl3 xl2 yl2 xl1 yl1 xt12 yt12
            
            set([s1,l5,l4,l3,l2,l1,t12],'Visible','off');
            
        case 'No'
            
            break 
            
    end
    
end

Set_Selection_Handels_On_Fcn (hObject, eventdata, handles)

save([pwd,'\Archive\',SubjectID,'\Levels'],'xs1','ys1','xl5','yl5','xl4','yl4','xl3','yl3','xl2','yl2','xl1','yl1','xt12','yt12')

img = evalin('base','img');

set(gca, 'XLim', [xl3 - 100, xl4 + 100], 'YLim', [yl1 - 100, ys1 + 100]);


% --- Executes on button press in L1-2 level(pushbutton8).
function pushbutton8_Callback(hObject, eventdata, handles)

global img xl2 yl2 xl1 yl1 disc xmin ymin xmax ymax s1 l5 l4 l3 l2 l1 t12

try 
    
    set([handles.uipanel13, s1, l5, l4, l3, l2, l1, t12], 'Visible', 'off');

catch me %#ok<*NASGU>

end

set([handles.axes1,handles.uipanel1],'visible','on');

img=evalin('base','img');

axes(handles.axes1);

imshow(img,[]);

disc=1;

Removing_Zoom_Information_Fcn(hObject, eventdata, handles)

xmin=round(xl1-80);

ymin=round(yl1);

xmax=round(xl2+80);

ymax=round(yl2);

Assigning_Zoom_Information_Fcn(hObject, eventdata, handles)

set(handles.axes1,'XLim',[xmin,xmax],'YLim',[ymin,ymax]);

Set_Selection_Handels_Off_Fcn (hObject, eventdata, handles)

set(handles.edit2,'String','L1-2 Disc');

set(handles.pushbutton14,'Enable','off');

set(handles.pushbutton15,'Enable','on');

Moving_to_Desired_Level_Fcn(hObject, eventdata, handles)

guidata(hObject, handles);


% --- Executes on button press in L2-3 disc (pushbutton9).
function pushbutton9_Callback(hObject, eventdata, handles)

global img xl2 yl2 xl3 yl3 disc xmin ymin xmax ymax s1 l5 l4 l3 l2 l1 t12

try 
    
    set([handles.uipanel13,s1,l5,l4,l3,l2,l1,t12],'Visible','off');

catch me

end

set([handles.axes1,handles.uipanel1],'visible','on');

img=evalin('base','img');axes(handles.axes1);

imshow(img,[]);

disc=2;
Removing_Zoom_Information_Fcn(hObject, eventdata, handles)

xmin=round(xl2-80);

ymin=round(yl2);

xmax=round(xl3+80);

ymax=round(yl3);

Assigning_Zoom_Information_Fcn(hObject, eventdata, handles)

set(handles.axes1,'XLim',[xmin,xmax],'YLim',[ymin,ymax]);

Set_Selection_Handels_Off_Fcn (hObject, eventdata, handles)

set(handles.edit2,'String','L2-3 Disc');

set([handles.pushbutton14,handles.pushbutton15],'Enable','on');

Moving_to_Desired_Level_Fcn(hObject, eventdata, handles)

guidata(hObject, handles);


% --- Executes on button press in L3-4 disc (pushbutton10).
function pushbutton10_Callback(hObject, eventdata, handles)
global img xl4 yl4 xl3 yl3 disc xmin ymin xmax ymax s1 l5 l4 l3 l2 l1 t12

try 
    
    set([handles.uipanel13,s1,l5,l4,l3,l2,l1,t12],'Visible','off')

catch me

end
set([handles.axes1,handles.uipanel1],'visible','on');

img=evalin('base','img');

axes(handles.axes1);

imshow(img,[]);disc=3;

Removing_Zoom_Information_Fcn(hObject, eventdata, handles)

xmin=round(xl3-80);

ymin=round(yl3);

xmax=round(xl4+80);

ymax=round(yl4);

Assigning_Zoom_Information_Fcn(hObject, eventdata, handles)

set(handles.axes1,'XLim',[xmin,xmax],'YLim',[ymin,ymax]);

Set_Selection_Handels_Off_Fcn (hObject, eventdata, handles)

set(handles.edit2,'String','L3-4 Disc');

set([handles.pushbutton14,handles.pushbutton15],'Enable','on');

Moving_to_Desired_Level_Fcn(hObject, eventdata, handles)

guidata(hObject, handles);


% --- Executes on button press in L4-5 disc (pushbutton11).
function pushbutton11_Callback(hObject, eventdata, handles)

global img xl4 yl4 xl5 yl5 disc xmin ymin xmax ymax s1 l5 l4 l3 l2 l1 t12

try 
    
    set([handles.uipanel13,s1,l5,l4,l3,l2,l1,t12],'Visible','off');

catch me

end

set([handles.axes1,handles.uipanel1],'visible','on');

img=evalin('base','img');

axes(handles.axes1);

imshow(img,[]);

disc=4;

Removing_Zoom_Information_Fcn(hObject, eventdata, handles)

xmin=round(xl4-80);

ymin=round(yl4-20);

xmax=round(xl5+80);

ymax=round(yl5+20);

Assigning_Zoom_Information_Fcn(hObject, eventdata, handles)

set(handles.axes1,'XLim',[xmin,xmax],'YLim',[ymin,ymax]);

Set_Selection_Handels_Off_Fcn (hObject, eventdata, handles)

set(handles.edit2,'String','L4-5 Disc');

set([handles.pushbutton14,handles.pushbutton15],'Enable','on');

Moving_to_Desired_Level_Fcn(hObject, eventdata, handles)

guidata(hObject, handles);


% --- Executes on button press in L5-S1 disc (pushbutton12).
function pushbutton12_Callback(hObject, eventdata, handles)

global img xs1 ys1 xl5 yl5 disc xmin ymin xmax ymax s1 l5 l4 l3 l2 l1 t12

try 
    set([handles.uipanel13,s1,l5,l4,l3,l2,l1,t12],'Visible','off');

catch me

end

set([handles.axes1,handles.uipanel1],'visible','on');

img=evalin('base','img');

axes(handles.axes1);

imshow(img,[]);

disc=5;

Removing_Zoom_Information_Fcn(hObject, eventdata, handles)

xmin=round(xl5-80);

ymin=round(yl5-30);

xmax=round(xs1+80);

ymax=round(ys1+30);

Assigning_Zoom_Information_Fcn(hObject, eventdata, handles)

set(handles.axes1,'XLim',[xmin,xmax],'YLim',[ymin,ymax]);

Set_Selection_Handels_Off_Fcn (hObject, eventdata, handles)

set(handles.edit2,'String','L5-S1 Disc');

set(handles.pushbutton14,'Enable','on');

set(handles.pushbutton15,'Enable','off');

Moving_to_Desired_Level_Fcn(hObject, eventdata, handles)

guidata(hObject, handles);


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Changing the level
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% --- Executes on button press in previous level (pushbutton14).
function pushbutton14_Callback(hObject, eventdata, handles)

global disc SubjectID hFH %#ok<NUSED>

try 
    
    set(hFH,'Visible','off');

catch me

end

evalin( 'base', 'clearvars -except img DIIinfo PathName SubjectID xul* yul* xdl* ydl* xl* yl* xs1 ys1' )

Turn_the_Keys_Off_Fcn(hObject, eventdata, handles)

set([handles.uipanel11,handles.uipanel6,handles.uipanel3],'visible','off')

set([handles.text6,handles.text7,handles.edit1,handles.edit2],'visible','on')

set(handles.edit1,'String',num2str(evalin('base','SubjectID')))

if disc==2
    
    pushbutton8_Callback(hObject, eventdata, handles)% L1-2 Disc
    
elseif disc==3
    
    pushbutton9_Callback(hObject, eventdata, handles)% L2-3 Disc
    
elseif disc==4
    
    pushbutton10_Callback(hObject, eventdata, handles)% L3-4 Disc
    
elseif disc==5
    
    pushbutton11_Callback(hObject, eventdata, handles)% L4-L5 Disc
    
end


% --- Executes on button press in next level (pushbutton15).
function pushbutton15_Callback(hObject, eventdata, handles)

global disc SubjectID hFH %#ok<NUSED>

try 
    
    set(hFH,'Visible','off');

catch me

end

evalin( 'base', 'clearvars -except img DIIinfo PathName SubjectID xul* yul* xdl* ydl* xl* yl* xs1 ys1' )

Turn_the_Keys_Off_Fcn(hObject, eventdata, handles)

set([handles.uipanel11,handles.uipanel6,handles.uipanel3],'visible','off')

set([handles.text6,handles.text7,handles.edit1,handles.edit2],'visible','on')

set(handles.edit1,'String',num2str(evalin('base','SubjectID')))

if disc==1
    
    pushbutton9_Callback(hObject, eventdata, handles)% L2-3 Disc
    
elseif disc==2
    
    pushbutton10_Callback(hObject, eventdata, handles)% L3-4 Disc
    
elseif disc==3
    
    pushbutton11_Callback(hObject, eventdata, handles)% L4-5 Disc
    
elseif disc==4
    
    pushbutton12_Callback(hObject, eventdata, handles)% L5-S1 Disc
    
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Disc Segmentation Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%{ 
    This is the main part of the program, do not amend of modify that.
    Segmentation begins by drawing a line through the vertebral body along the superior endplate of the disc below. 
    By searching vertically below each pixel along the drawn line, the program then determines the pixels 
    with maximum signal intensity difference as the upper boundary of the disc. 
    A similar strategy will be used for segmentation of the inferior boundary of the disc, searching vertically above 
    the line drawn by the user. 
    To locate the anterior and posterior corners of the vertebrae, 20 pixels adjacent to the initial endpoints will be scanned further anteriorly or posteriorly. 
    The pixel with maximum signal intensity difference in the anterior-posterior direction will be then selected as the vertebra endpoint on each side. 
    Users are able to modify the location of individual disc boundary pixels in the case of outlier errors.
    For more information, please consult the following paper:
    Abdollah V, Parent EC, Battié MC. "Is the location of the signal intensity weighted centroid a reliable measurement of fluid displacement within the disc?"
    Biomed Tech (Berl). 2017 Jun 20
    https://www.ncbi.nlm.nih.gov/pubmed/28632492
%}

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Upper Line
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% Function for drawing the upper line
function Upper_Line_Drawer_Function(hObject, eventdata, handles)

global img xul yul xlsl xrsl hFH j s1 l5 l4 l3 l2 l1 t12 disc Shima

Shima=0;

clc

clear xul yul

if disc==1
    
    evalin('base','clear xul1');evalin('base','clear yul1');
    
    evalin('base','clear xdl1');evalin('base','clear ydl1');
    
elseif disc==2
    
    evalin('base','clear xul2');evalin('base','clear yul2');
    
    evalin('base','clear xdl2');evalin('base','clear ydl2');
    
elseif disc==3
    
    evalin('base','clear xul3');evalin('base','clear yul3');
    
    evalin('base','clear xdl3');evalin('base','clear ydl3');
    
elseif disc==4
    
    evalin('base','clear xul4');evalin('base','clear yul4');
    
    evalin('base','clear xdl4');evalin('base','clear ydl4');
    
elseif disc==5
    
    evalin('base','clear xul5');evalin('base','clear yul5');
    
    evalin('base','clear xdl5');evalin('base','clear ydl5');
    
end

Set_2nd_Measurement_Keys_Off_Fcn(hObject, eventdata, handles)

try 
    
    set([s1,l5,l4,l3,l2,l1,t12],'Visible','off');

catch me

end

waitfor(warndlg('Please draw a line tangent to the inferior endplate of the superior vertebra!','MR Image Processing'));

c=getline(handles.axes1);

xrsl=round(c(1,1));

yrsl=round(c(1,2));

xlsl=round(c(2,1));

ylsl=round(c(2,2));

m1=polyfit([xrsl xlsl],[yrsl ylsl],1);

nori=ceil(sqrt((xrsl-xlsl).^2+(yrsl-ylsl).^2));

for j=1:nori
    
    xulu(j)=xlsl+(2*(j-1));
    
    if gt(xulu(j),xrsl)
        
        xulu(j)=[];
        
        break
    
    end
    
    yulu(j)=m1(1,1)*xulu(j)+m1(1,2);
    
    if ge(j,floor(0.8*nori))
        
        yuld(j)=yulu(j)+14;
        
    else
        
        yuld(j)=yulu(j)+10;
        
    end
    
    xuld(j)=xulu(j)-m1(1,1)*(yuld(j)-yulu(j));
    
    [~,cul]=min(improfile(img,[xulu(j) xuld(j)],[yulu(j) yuld(j)]));
    
    yupmi(j)=(yulu(j)+cul);xupmi(j)=xulu(j)-m1(1,1)*(yupmi(j)-yulu(j));
    
    for k=1:6
        
        yupmax(k)=yupmi(j)-(k-1);
        
        xupmax(k)=xupmi(j)-m1(1,1)*(yupmax(k)-yupmi(j));
        
        sipup(k)=improfile(img,xupmax(k),yupmax(k));
        
        if ge(k,2);dupdh(k)=sipup(k)-sipup(k-1);end
    end
    
    dupdh(1)=[];
    
    [~,mdb2pp]=max(dupdh);
    
    yul(j)=yupmax(mdb2pp);
    
    xul(j)=xupmax(mdb2pp);     
end

B=transpose([xul; yul]);

hFH=impoly(gca,B,'Closed',false);

setColor(hFH,'g'); %#ok<*IMPOLY>

set([handles.uipanel3,handles.pushbutton18,handles.pushbutton25],'visible','on')


% --- Executes on button press in redrawing the line (pushbutton25).
function pushbutton25_Callback(hObject, eventdata, handles)
global hFH

clear xlsl xrsl

try 
    
    set(hFH,'Visible','off');

catch me

end

Upper_Line_Drawer_Function(hObject, eventdata, handles)


% --- Executes on button press in confriming the superior line (pushbutton18).
function pushbutton18_Callback(hObject, eventdata, handles)
global hFH xuln yuln SubjectID disc

set([handles.uipanel3,handles.pushbutton18,handles.pushbutton25],'visible','off')

Coords=getPosition(hFH);

xuln=transpose(Coords(:,1));

yuln=transpose(Coords(:,2));

save([pwd,'\Archive\',SubjectID,'\xuln ',num2str(disc)],'xuln')

save([pwd,'\Archive\',SubjectID,'\yuln ',num2str(disc)],'yuln')

try 
    
    set(hFH,'Visible','off');

catch me

end

Lower_Line_Drawer_Function(hObject, eventdata, handles)


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Lower Line
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% Function for drawing the lower line
function Lower_Line_Drawer_Function(hObject, eventdata, handles)

global img xdl ydl xlil xril hFH

clc

clear xdl ydl

waitfor(warndlg('Please draw a line tangent to the superior endplate of the inferior vertebra!','MR Image Processing'));

c=getline(handles.axes1);  

xril=round(c(1,1));

yril=round(c(1,2));

xlil=round(c(2,1));

ylil=round(c(2,2));

m2=polyfit([xril xlil],[yril ylil],1);

nori=ceil(sqrt((xril-xlil).^2+(yril-ylil).^2));

for j=1:nori
    
	xdld(j)=xlil+(2*(j-1));
    
    if gt(xdld(j),xril)
        
        xdld(j)=[];
        
        break;
    
    end
    
    ydld(j)=m2(1,1)*xdld(j)+m2(1,2);
    
    if ge(j,floor(0.8*nori))
        
        ydlu(j)=ydld(j)-8;
        
    else
        
        ydlu(j)=ydld(j)-6;
        
    end
    
    xdlu(j)=xdld(j)+m2(1,1)*(ydld(j)-ydlu(j));
    
    [~,cdl(j)]=min(improfile(img,[xdlu(j) xdld(j)],[ydlu(j) ydld(j)]));    
    
    ydpmi(j)=(ydlu(j)+cdl(j));xdpmi(j)=xdlu(j)-m2(1,1)*(ydpmi(j)-ydlu(j));
    
    for k=1:6
        
        ydpmax(k)=ydpmi(j)-(k-1);
        
        xdpmax(k)=xdpmi(j)-m2(1,1)*(ydpmax(k)-ydpmi(j));
        
        sipld(k)=improfile(img,xdpmax(k),ydpmax(k));
        
        if ge(k,2)
            
            dlpdh(k)=(sipld(k-1)-sipld(k));
        
        end
        
    end
    
    dlpdh(1)=[];[~,mdb2pd]=max(dlpdh);
    
    ydl(j)=ydpmax(mdb2pd);
    
    xdl(j)=xdpmax(mdb2pd);
    
end

B=transpose([xdl; ydl]);

hFH=impoly(gca,B,'Closed',false);

setColor(hFH,'r');

set([handles.uipanel3,handles.pushbutton19,handles.pushbutton26],'visible','on')


% --- Executes on button press in redrawing the line (pushbutton26).
function pushbutton26_Callback(hObject, eventdata, handles)

global hFH

clear xlil xril

try 
    
    set(hFH,'Visible','off');

catch me

end

Lower_Line_Drawer_Function(hObject, eventdata, handles)


% --- Executes on button press in confriming the inferior line (pushbutton19).
function pushbutton19_Callback(hObject, eventdata, handles)

global hFH xdln ydln SubjectID disc

set([handles.uipanel3,handles.pushbutton19,handles.pushbutton26],'visible','off');

Coords=getPosition(hFH);

xdln=transpose(Coords(:,1));

ydln=transpose(Coords(:,2));

save([pwd,'\Archive\',SubjectID,'\xdln ',num2str(disc)],'xdln')

save([pwd,'\Archive\',SubjectID,'\ydln ',num2str(disc)],'ydln')

try set(hFH,'Visible','off')

catch me

end

Anterior_Wall_Drawer_Function(hObject, eventdata, handles)


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Anterior Line
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% Function for determining the anterior wall of the disc
function Anterior_Wall_Drawer_Function(hObject, eventdata, handles)

global img xdln ydln xuln yuln m3 xs disc xawd yawd hFH

clc

clear xawd yawd

Angle_Calculator_Fcn

try
    for i=1:200
        
        if le(disc,3)
            
            yawdl(i)=yuln(1)+2*(i-1);
            
            if ge(yawdl(i),ydln(1)+4)
                
                yawdl(i)=[];
                
                break
                
            else
                for j=1:5
                    
                    xawdr(j)=xs+j;
                    
                    if ge(xuln(1),xdln(1))
                        
                        if ge(xawdr(j), xuln(1))
                            
                            xawdr(j)=[];
                            
                            break
                        
                        end
                    else
                        
                        if ge(xawdr(j),xdln(1))
                            
                            xawdr(j)=[];
                            
                            break
                        
                        end
                    end
                    yawdr(j)=yawdl(i)-m3*(xs-xawdr(j));
                    
                    cawd(j)=max(improfile(img,xawdr(j),yawdr(j)));
                    
                    if ge(j,2)
                        
                        db2pp(j)=abs(cawd(j)-cawd(j-1));
                    
                    end
                end
                
                db2pp(1)=[];
                
                [~,idxr]=max(db2pp);
                
                xawd(i)=xawdr(idxr);
                
                yawd(i)=yawdr(idxr);
                
            end
        else
            
            ydlee=(-5*((ydln(1)-ydln(numel(ydln)))/(xdln(1)-xdln(numel(xdln)))))+ydln(1);
            
            yawd(i)=yuln(1)+2*i;
            
            if ge(yawd(i),ydlee)
                
                yawd(i)=[];
                
                break
                
            end
            
            xawdr(i)=(xuln(1)-(yuln(1)-yawd(i))/((yuln(1)-ydln(1))/(xuln(1)-xdln(1))));
            
            xawdl(i)=xdln(1)-1;
            
            for j=1:abs(floor(xawdl(i)-xawdr(i)))
                
                xawdb(i,j)=xawdr(i)-j;
                
                sidawd(j)=improfile(img,xawdb(i,j),yawd(i));
                
                if ge(j,2)
                    
                    dawd(j)=sidawd(j-1)-sidawd(j);
                
                end
            end
            
            dawd(1)=[];
            
            [~,mdb2awdu(i)]=min(dawd);
            
            xawd(i)=xawdr(i)-mdb2awdu(i);
            
            if ge(i,2)&&ge(xawd(i),xawd(i-1)+2)
                
                xawd(i)=xawd(i-1)+2;
            
            end
            
        end
        
    end
    
catch me
    
    waitfor(errordlg('I am unable to find the anterior wall, you should draw it yourself!','MR Image Processing GUI')); 
    
    hFHm=impoly(gca,'Closed',false);
    
    Coords=getPosition(hFHm);
    
    xawd=transpose(Coords(:,1));
    
    yawd=transpose(Coords(:,2));
    
    set(hFHm,'Visible','off')
    
end

B=transpose([xawd; yawd]);

hFH=impoly(gca,B,'Closed',false);

setColor(hFH,'y');

Edditing_Tool_Box_Keys_Off_Fcn(hObject, eventdata, handles)

set([handles.uipanel3,handles.pushbutton20,handles.pushbutton55],'visible','on')


% --- Executes on button press in confriming the anterior line (pushbutton20).
function pushbutton20_Callback(hObject, eventdata, handles)

global hFH xawdn yawdn 

set([handles.uipanel3,handles.pushbutton20,handles.pushbutton55],'visible','off')

Coords=getPosition(hFH);

xawdn=transpose(Coords(:,1));

yawdn=transpose(Coords(:,2));

try 
    
    set(hFH,'Visible','off');

catch me

end

Posterior_Wall_Drawer_Function(hObject, eventdata, handles)


% --- Executes on button press in redoing (pushbutton55).
function pushbutton55_Callback(hObject, eventdata, handles)

global hFH xawd yawd

set(hFH,'Visible','off')

waitfor(warndlg('Please draw the line manually!','MR Image Processing GUI'));

hFHm=impoly(gca,'Closed',false);

Coords=getPosition(hFHm);

xawd=transpose(Coords(:,1));

yawd=transpose(Coords(:,2));

try 
    
    set(hFHm,'Visible','off');

catch me

end
B=transpose([xawd; yawd]);

hFH=impoly(gca,B,'Closed',false);

setColor(hFH,'y');


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Posterior Line
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% Function for determining the posterior wall of the disc
function Posterior_Wall_Drawer_Function(hObject, eventdata, handles)

global img xdln ydln xuln yuln m3 xe xpwd ypwd hFH

clc

Angle_Calculator_Fcn

clear xpwd ypwd

try
    
    for i=1:200
        
        ypwdl(i)=yuln(numel(yuln))+2*(i-1);
        
        if ge(ypwdl(i),ydln(numel(ydln))+2)
            
            ypwdl(i)=[];
            
            break
            
        else
            
            for j=1:5
                
                xpwdr(j)=xe+j;
                
                if le(xuln(numel(xuln)),xdln(numel(xdln)))
                    
                    if le(xpwdr(j),xuln(numel(xuln)))
                        
                        xpwdr(j)=[];
                        
                        break
                    
                    end
                else
                    
                    if le(xpwdr(j),xdln(numel(xdln)))
                        
                        xpwdr(j)=[];
                        
                        break
                    
                    end
                    
                end
                
                ypwdr(j)=ypwdl(i)-m3*(xe-xpwdr(j));
                
                cpwd(j)=max(improfile(img,xpwdr(j),ypwdr(j)));
                
                if ge(j,2)
                    
                    db2pp(j)=abs(cpwd(j)-cpwd(j-1));
                
                end
            end
            
            db2pp(1)=[];
            
            [~,idxr]=max(db2pp);
            
            xpwd(i)=xpwdr(idxr);
            
            ypwd(i)=ypwdr(idxr);
            
        end
        
    end
    
catch me
    
    waitfor(errordlg('I am unable to find the posterior wall, you should draw it yourself!','MR Image Processing GUI'));
    
    hFH=impoly(gca,'Closed',false);
    
    Coords=getPosition(hFH);
    
    xpwd=Coords(:,1);
    
    ypwd=Coords(:,2);    
    
end

B=transpose([xpwd; ypwd]);

hFH=impoly(gca,B,'Closed',false);

setColor(hFH,'y');

Edditing_Tool_Box_Keys_Off_Fcn(hObject, eventdata, handles)

set([handles.uipanel3,handles.pushbutton21,handles.pushbutton56],'visible','on')


% --- Executes on button press in redo (pushbutton55).
function pushbutton56_Callback(hObject, eventdata, handles)

global hFH xpwd ypwd

set(hFH,'Visible','off')

waitfor(warndlg('Please draw the line manually!','MR Image Processing GUI'));

hFHm=impoly(gca,'Closed',false);

Coords=getPosition(hFHm);

xpwd=transpose(Coords(:,1));

ypwd=transpose(Coords(:,2));

set(hFHm,'Visible','off')

B=transpose([xpwd; ypwd]);

hFH=impoly(gca,B,'Closed',false);

setColor(hFH,'y');


% --- Executes on button press in confriming the posterior line(pushbutton21).
function pushbutton21_Callback(hObject, eventdata, handles)

global hFH xpwdn ypwdn

set([handles.uipanel3,handles.pushbutton21,handles.pushbutton56],'visible','off')

Coords=getPosition(hFH);

xpwdn=transpose(Coords(:,1));

ypwdn=transpose(Coords(:,2));

try 
    
    set(hFH,'Visible','off')

catch me

end

Disc_ROI_Drawer_Function(hObject, eventdata, handles)

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           ROI Drawer Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% ROI Drawer Function
function Disc_ROI_Drawer_Function(hObject, eventdata, handles)

global SubjectID disc xuln xpwdn xdln xawdn yuln ypwdn ydln yawdn hFH Vahid

clc

Vahid=1;

try 
    set(hFH,'Visible','off')

catch me

end

set(handles.pushbutton17,'visible','off')

xroid=round([xuln,xpwdn,fliplr(xdln),fliplr(xawdn)]);

yroid=round([yuln,ypwdn,fliplr(ydln),fliplr(yawdn)]);

B=transpose([xroid; yroid]);

hFH=impoly(gca,B);

setColor(hFH,'g');

save([pwd,'\Archive\',SubjectID,'\Disc Level ',num2str(disc)],'B')

BUB=[xuln; yuln];

save([pwd,'\Archive\',SubjectID,'\Disc Upper Border Level ',num2str(disc)],'BUB')

BLB=[xdln; ydln];

save([pwd,'\Archive\',SubjectID,'\Disc Lower Border Level ',num2str(disc)],'BLB')

set([handles.pushbutton14,handles.pushbutton15],'visible','on');

if disc==1
    
    set(handles.pushbutton14,'Enable','off');
    
elseif disc==5 
    
    set(handles.pushbutton15,'Enable','off');
    
end
set([handles.pushbutton30,handles.pushbutton68],'visible','on')

set([handles.pushbutton33,handles.pushbutton34,handles.pushbutton35,handles.pushbutton36,handles.pushbutton37,handles.pushbutton38,...
    handles.pushbutton45],'visible','on','Enable','off')

if disc==1
    
    assignin('base','xul1',xuln)
    
    assignin('base','yul1',yuln)
    
    assignin('base','xdl1',xdln)
    
    assignin('base','ydl1',ydln)
    
elseif disc==2
    
    assignin('base','xul2',xuln)
    
    assignin('base','yul2',yuln)
    
    assignin('base','xdl2',xdln)
    
    assignin('base','ydl2',ydln)
    
elseif disc==3
    
    assignin('base','xul3',xuln)
    
    assignin('base','yul3',yuln)
    
    assignin('base','xdl3',xdln)
    
    assignin('base','ydl3',ydln)
    
elseif disc==4
    
    assignin('base','xul4',xuln)
    
    assignin('base','yul4',yuln)
    
    assignin('base','xdl4',xdln)
    
    assignin('base','ydl4',ydln)
    
elseif disc==5
    
    assignin('base','xul5',xuln)
    
    assignin('base','yul5',yuln)
    
    assignin('base','xdl5',xdln)
    
    assignin('base','ydl5',ydln)
    
end

pushbutton17_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Nucleus Segmentation Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in nucleus pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)

global img B hFH hFHNucu hFHNucl xuln yuln xdln ydln xs xe m3 xun yun xdn ydn Vahid

clc

Vahid=2;

try 
    
    set(hFH,'Visible','off');

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

clear xun yun xdn ydn

set([handles.pushbutton17,handles.pushbutton30,handles.pushbutton33,handles.pushbutton34,handles.pushbutton35,...
    handles.pushbutton36,handles.pushbutton37,handles.pushbutton38,handles.pushbutton68,handles.pushbutton45,...
    handles.uipanel6,handles.uipanel11],'visible','off');

xl=(xuln(1)+xdln(1))/2;

yl=(yuln(1)+ydln(1))/2; 

xr=(xuln(numel(xuln))+xdln(numel(xdln)))/2;

yr=(yuln(numel(yuln))+ydln(numel(ydln)))/2;

mmds=(yl-yr)/(xl-xr);

incpt=yl-mmds*xl;

for i=1:200
    
    xsp(i)=xs+(2*(i-1)*cos(mmds))+5;
    
    if gt(xsp(i),xe-2)
        
        xsp(i)=[];
        
        break;
    
    end
    
    ysp(i)=mmds*xsp(i)+incpt;
    
    sidml(i)=improfile(img,xsp(i),ysp(i));
    
    if ge(i,2)
        
        sidopodbl(i)=abs(sidml(i)-sidml(i-1));
    
    end

end

nopodbl=numel(sidopodbl);

% left half of the disc

ltodbl=sidopodbl(1:floor(nopodbl/3));

for i=1:3
    
    ltodbl(i)=[];

end

[~,locsl]=max(ltodbl);

xsn=xsp(locsl);ysn=ysp(locsl);

% right half of the disc

ltodbr=sidopodbl(floor((2*nopodbl)/3):numel(sidopodbl));

for i=1:3
    
    ltodbr(numel(ltodbr))=[];

end

[~,locsr]=max(ltodbr);

xen=xsp(floor((2*numel(xsp))/3)+locsr);

yen=ysp(floor((2*numel(xsp))/3)+locsr);

NOI=floor(sqrt((xen-xsn).^2+(yen-ysn).^2));

for i=1:NOI

    xsna(i)=xsn+2*i;
    
    if ge(xsna(i),xen);xsna(i)=[];break;end
    
    ysna(i)=m3*(xsna(i)-xsn)+ysn;    
    
    [~,ibc]=min(abs(xuln-xsna(i)));
    
    for j=1:floor(ysna(i)-yuln(ibc))
    
        sipup(j)=improfile(img,xsna(i),ysna(i)-j);
        
        if ge(j,2)
            
            dup(j)=sipup(j-1)-sipup(j);
        
        end
        
    end    
    
    dup(1)=[];
    
    [~,msul]=max(dup);
    
    yun(i)=ysna(i)-msul;
    
    xun(i)=xsna(i);

end

%Removing possible outliers

for i=2:numel(yun)-1
    
    if ge(yun(i),yun(i-1)+1)&&ge(yun(i),yun(i+1)+1)
        
        yun(i)=(yun(i-1)+yun(i-1))/2;
        
    end
    
    if le(yun(i),yun(i-1)-1)&&ge(yun(i),yun(i+1)-1)
        
        yun(i)=(yun(i-1)+yun(i+1))/2;
        
    end
    
end

for i=1:NOI
    
    xsna(i)=xsn+2*i;
    
    if ge(xsna(i),xen)
        
        xsna(i)=[];
        
        break;
    
    end
    
    ysna(i)=m3*(xsna(i)-xsn)+ysn;
    
    [~,ibc]=min(abs(xdln-xsna(i)));
    
    for j=1:floor(ydln(ibc)-ysna(i))
        
        siplp(j)=improfile(img,xsna(i),ysna(i)+j);
        
        if ge(j,2)
            
            dlp(j)=siplp(j)-siplp(j-1);
        
        end
        
    end
    
    dlp(1)=[];
    
    [~,msll]=min(dlp);
    
    ydn(i)=ysna(i)+msll;
    
    xdn(i)=xsna(i);

end

% Removing possible outliers

for i=2:numel(ydn)-1
    
    if ge(ydn(i),ydn(i-1)+1)&&ge(ydn(i),ydn(i+1)+1)
        
        ydn(i)=(ydn(i-1)+ydn(i-1))/2;
        
    end
    
    if le(ydn(i),ydn(i-1)-1)&&ge(ydn(i),ydn(i+1)-1)
        
        ydn(i)=(ydn(i-1)+ydn(i+1))/2;
        
    end
    
end

% Determining signal intensity of the pixels of the upper and lower borders of the nucleus

m1=polyfit(xuln,yuln,1);m2=polyfit(xdln,ydln,1);

m1n=polyfit(xun,yun,1);m2n=polyfit(xdn,ydn,1);m3n=(m1n(1,1)+m2n(1,1))/2;

for i=1:30
    
    xull(i)=xuln(1)-i;
    
    yull(i)=yuln(1)-m1(1,1)*(xuln(1)-xull(i));
    
    xulr(i)=xuln(numel(xuln))+i;
    
    yulr(i)=yuln(numel(xuln))-m1(1,1)*(xuln(numel(xuln))-xulr(i));
    
    xdll(i)=xdln(1)-i;
    
    ydll(i)=ydln(1)-m2(1,1)*(xdln(1)-xdll(i));
    
    xdlr(i)=xdln(numel(xdln))+i;
    
    ydlr(i)=ydln(numel(xdln))-m2(1,1)*(xdln(numel(xdln))-xdlr(i));

end

xulm=[fliplr(xull),xuln,xulr];

yulm=[fliplr(yull),yuln,yulr];

xdlm=[fliplr(xdll),xdln,xdlr];

ydlm=[fliplr(ydll),ydln,ydlr];

[xuintl,yuintl]=polyxpoly(xulm,yulm,[xsn+20*m3 xsn-20*m3],[ysn-20 ysn+20]);

[xlintl,ylintl]=polyxpoly(xdlm,ydlm,[xsn+20*m3 xsn-20*m3],[ysn-20 ysn+20]);

xma=(xuintl+xlintl)/2;

yma=(yuintl+ylintl)/2;    

[xuintr,~]=polyxpoly(xulm,yulm,[xen+20*m3 xen-20*m3],[yen-20 yen+20]);

[xlintr,~]=polyxpoly(xdlm,ydlm,[xen+20*m3 xen-20*m3],[yen-20 ysn+20]);

xmp=(xuintr+xlintr)/2;

% Superior boundary of the nucleus

try
    for i=1:100
        
        xns(i)=xma+4*(i-1);
        
        if gt(xns(i),xmp)
            
            xns(i)=[];
            
            break
            
        else
            yns(i)=yma-m3n*(xma-xns(i));
            
            [xuls(i),yuls(i)]=polyxpoly(xulm,yulm,[xns(i)+20*m3n xns(i)-20*m3n],[yns(i)-20 yns(i)+20]);
            
            nopsbs(i)=floor(sqrt((xns(i)-xuls(i)).^2+(yns(i)-yuls(i)).^2));
            
            if le(nopsbs(i),2)
                
                nopsbs(i)=3;
            
            end
            
            for j=1:nopsbs(i)
                
                ynsu(j)=yns(i)-j;
                
                if le(ynsu(j),yuls(i))
                    
                    ynsu(j)=[];
                    
                    break;
                
                else
                    xnsu(j)=xns(i)-m3n*(ynsu(j)-yns(i));
                    
                    sibu(j)=improfile(img,xnsu(j),ynsu(j));
                    
                    if ge(j,2)
                        
                        dup(j)=abs(sibu(j-1)-sibu(j));
                    
                    end
                    
                end
                
            end
            
            cdup=numel(dup);
            
            if ge(cdup,2)
                
                dup(1)=[];
                
                [~,msiu]=max(dup);
                
                yunv(i)=ynsu(msiu);
                
                xunv(i)=xnsu(msiu);
            else
                
                yunv(i)=yns(i);
                
                xunv(i)=xns(i);
                
            end
            
        end
        
    end
    
catch me

end

exunv=exist('xunv','var');

if exunv==0;yunv=yun;xunv=xun;end

% Inferior boundary of the nucleus

try
    
    for i=1:100
        
        xns(i)=xma+4*(i-1);
        
        if gt(xns(i),xmp)
            
            xns(i)=[];
            
            break
            
        else
            
            yns(i)=yma-m3n*(xma-xns(i));
            
            [xlls(i),ylls(i)]=polyxpoly(xdlm,ydlm,[xns(i)+20*m3n xns(i)-20*m3n],[yns(i)-20 yns(i)+20]);
            
            nopsbsl(i)=floor(sqrt((xns(i)-xlls(i)).^2+(yns(i)-ylls(i)).^2));
            
            if le(nopsbsl(i),2)
                
                nopsbsl(i)=3;
            
            end
            
            for j=1:nopsbsl
                
                ynsl(j)=yns(i)+j;
                
                if ge(ynsl(j),ylls(i))
                    
                    ynsl(j)=[];
                    
                    break
                    
                else
                    xnsl(j)=xns(i)-m3n*(ynsl(j)-yns(i));
                    
                    sibd(j)=improfile(img,xnsl(j),ynsl(j));
                    
                    if ge(j,2)
                        
                        dlp(j)=abs(sibd(j-1)-sibd(j));
                    
                    end
                    
                end 
                
            end
            
            cdlp=numel(dlp);
            
            if ge(cdlp,2)
                
                dlp(1)=[];
                
                [~,msil]=max(dlp);
                
                ydnv(i)=ynsl(msil);
                
                xdnv(i)=xnsl(msil);
                
            else
                
                ydnv(i)=yns(i);xdnv(i)=xns(i);
                
            end
            
        end
    end
    
catch me

end

exdnv=exist('xdnv','var');

if exdnv==0
    
    ydnv=ydn;
    
    xdnv=xdn;

end

B=transpose([xun; yun]);

hFHNucu=impoly(gca,B,'Closed',false);

setColor(hFHNucu,'y');

B=transpose([xdn; ydn]);

hFHNucl=impoly(gca,B,'Closed',false);

setColor(hFHNucl,'r');

Edditing_Tool_Box_Keys_Off_Fcn(hObject, eventdata, handles)

set(handles.uipanel12,'visible','on');


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                       Drawing the Line(s) Manually
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in redrawing the upper line (pushbutton111).
function pushbutton111_Callback(hObject, eventdata, handles)

global hFHNucu JAUL

JAUL=1;

set(hFHNucu,'Visible','off')

set(handles.pushbutton47,'string','Done');

hFHNucu=impoly(gca,'Closed',false);

setColor(hFHNucu,'g');


% --- Executes on button press in redrawing the lower line (pushbutton112).
function pushbutton112_Callback(hObject, eventdata, handles)

global hFHNucl JALL

JALL=1;

set(hFHNucl,'Visible','off')

set(handles.pushbutton47,'string','Done');

hFHNucl=impoly(gca,'Closed',false);

setColor(hFHNucl,'g');


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Confirming the ROI
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in confirming ROI (pushbutton47).
function pushbutton47_Callback(hObject, eventdata, handles)

global B hFH hFHNucu hFHNucl xunn yunn xdnn ydnn JAUL JALL

try set(hFH,'Visible','off');catch me;end

set(handles.pushbutton47,'string','No Need');

set(handles.pushbutton17,'visible','on')

set([handles.uipanel6,handles.uipanel11],'visible','off')

Coordsu=getPosition(hFHNucu);

if JAUL==1
    
    xunn=fliplr(transpose(Coordsu(:,1)));
    
    yunn=fliplr(transpose(Coordsu(:,2)));
    
else
    
    xunn=transpose(Coordsu(:,1));
    
    yunn=transpose(Coordsu(:,2));
    
end

Coordsl=getPosition(hFHNucl);

if JALL==1
    
    xdnn=fliplr(transpose(Coordsl(:,1)));
    
    ydnn=fliplr(transpose(Coordsl(:,2)));
    
else
    
    xdnn=transpose(Coordsl(:,1));
    
    ydnn=transpose(Coordsl(:,2));
    
end

xroin=round([xunn,fliplr(xdnn)]);

yroin=round([yunn,fliplr(ydnn)]);
try 
    
    set(hFHNucu,'Visible','off');
    
    set(hFHNucl,'Visible','off');

catch me

end

B=transpose([xroin; yroin]);

hFH=impoly(gca,B);

setColor(hFH,'r');

pushbutton17_Callback(hObject, eventdata, handles)

set(handles.uipanel12,'visible','off')


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                         Anterior Annulus Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in anterior annulus pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)

global B xunn xdnn xuln yuln xdln ydln xawdn yawdn xawn yawn xroiaa yroiaa hFH Vahid

Vahid=3;

clc

try 
    
    set(hFH,'Visible','off')

catch me

end

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off')

Zoom_FcnI(hObject, eventdata, handles)

xunl=xunn(1);

xdnl=xdnn(1);

[~,curoia]=min(abs(xuln-xunl));

[~,cdroia]=min(abs(xdln-xdnl));

xsaaf=xuln(1:curoia);

ysaaf=yuln(1:curoia);

xdaaf=xdln(1:cdroia);

ydaaf=ydln(1:cdroia);

xroiaa=[fliplr(xawdn),xsaaf,xawn,fliplr(xdaaf)];

yroiaa=[fliplr(yawdn),ysaaf,yawn,fliplr(ydaaf)];  

B=transpose([xroiaa; yroiaa]);

hFH=impoly(gca,B);

setColor(hFH,'y');

pushbutton17_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                        Posterior Annulus Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in posterior annulus (pushbutton34).
function pushbutton34_Callback(hObject, eventdata, handles)

global B xunn xdnn xuln yuln xdln ydln xpwdn ypwdn xpwn ypwn xroipa yroipa hFH Vahid

Vahid=4;

clc

try 
    
    set(hFH,'Visible','off')

catch me

end

set([handles.pushbutton17,handles.uipanel11],'visible','off')

Zoom_FcnI(hObject, eventdata, handles)

xunr=xunn(numel(xunn));

xdnr=xdnn(numel(xdnn));

[~,curoip]=min(abs(xuln-xunr));

[~,cdroip]=min(abs(xdln-xdnr)); 

xspaf=xuln(curoip:numel(xuln));

yspaf=yuln(curoip:numel(xuln));

xdpaf=xdln(cdroip:numel(xdln));

ydpaf=ydln(cdroip:numel(xdln));

xroipa=[fliplr(xpwdn),fliplr(xspaf),xpwn,xdpaf];

yroipa=[fliplr(ypwdn),fliplr(yspaf),ypwn,ydpaf];

B=transpose([xroipa; yroipa]);

hFH=impoly(gca,B);

setColor(hFH,'y');

pushbutton17_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                       Upper Fibrous Tissue Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press for superior fibrous tissue (pushbutton35).
function pushbutton35_Callback(hObject, eventdata, handles)

global xuln yuln xunn yunn hFH Vahid

Vahid=5;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

clc

try 
    
    set(hFH,'Visible','off')

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

[~,curoia]=min(abs(xuln-xunn(1)));

[~,curoip]=min(abs(xuln-xunn(numel(xunn))));

xsbsft=xuln(curoia:curoip);

ysbsft=yuln(curoia:curoip);

xroisf=[xunn,fliplr(xsbsft)];

yroisf=[yunn,fliplr(ysbsft)];

B=transpose([xroisf; yroisf]);

hFH=impoly(gca,B);

setColor(hFH,'c');

pushbutton17_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                              Lower Fibrous Tissue Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)

global xdln ydln xdnn ydnn hFH Vahid

Vahid=6;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

clc

try 
    
    set(hFH,'Visible','off')

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

[~,cdroia]=min(abs(xdln-xdnn(1)));

[~,cdroip]=min(abs(xdln-xdnn(numel(xdnn))));

xdbift=xdln(cdroia:cdroip);

ydbift=ydln(cdroia:cdroip);

xroiif=[xdnn,fliplr(xdbift)];

yroiif=[ydnn,fliplr(ydbift)];

B=transpose([xroiif; yroiif]);

hFH=impoly(gca,B);

setColor(hFH,'c');

pushbutton17_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Superior Endplate Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in superior endplate(pushbutton37).
function pushbutton37_Callback(hObject, eventdata, handles)

global img B xuln yuln xroise yroise hFH Vahid

Vahid=7;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

clc

try 
    
    set(hFH,'Visible','off')

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

for i=1:numel(xuln)
    
    xscep(i)=xuln(i);
    
    for j=1:3
        
        ysceb(j)=yuln(i)-j;
        
        sidup(j)=improfile(img,xscep(i),ysceb(j));
        
        if ge(j,2)
            
            dbpscep(j)=sidup(j)-sidup(j-1);
        
        end
        
    end
    
    dbpscep(1)=[];
    
    [~,msi4scep]=max(dbpscep);
    
    yscep(i)=ysceb(msi4scep);
    
end

xroise=round([xscep,fliplr(xuln)]);

yroise=round([yscep,fliplr(yuln)]);

B=transpose([xroise; yroise]);

hFH=impoly(gca,B);

setColor(hFH,'g');

answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');

switch answer
    
    case 'Yes'
        
        pushbutton17_Callback(hObject, eventdata, handles)
        
    case 'No'
        
        waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
        
        set(handles.pushbutton17,'visible','on');
        
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                               Inferior Endplate Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in inferior endplate (pushbutton38).
function pushbutton38_Callback(hObject, eventdata, handles)

global img B xdln ydln xroiie yroiie hFH Vahid disc

Vahid=8;

set([handles.uipanel11,handles.uipanel6],'visible','off');

clc

try set(hFH,'Visible','off');catch me;end

Zoom_FcnI(hObject, eventdata, handles)

for i=1:numel(xdln)
    
    xicep(i)=xdln(i);
    
    for j=1:3
        
        yiceb(j)=ydln(i)+j;
        
        sidlp(j)=improfile(img,xicep(i),yiceb(j));
        
        if ge(j,2)
            
            dbpicep(j)=sidlp(j)-sidlp(j-1);
        
        end
        
    end
    dbpicep(1)=[];[~,msi4icep]=max(dbpicep);
    
    yicep(i)=yiceb(msi4icep);
    
end

xroiie=round([xicep,fliplr(xdln)]);

yroiie=round([yicep,fliplr(ydln)]);

B=transpose([xroiie; yroiie]);

hFH=impoly(gca,B);

setColor(hFH,'g');

answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');

switch answer
    
    case 'Yes'
        
        pushbutton17_Callback(hObject, eventdata, handles)
        
    case 'No'
        
        waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
        
        set(handles.pushbutton17,'visible','on');
        
end

if disc==1
    
    set([handles.pushbutton45,handles.pushbutton61],'Enable','off');
    
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                     Vertebra Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in vertebra (pushbutton45).
function pushbutton45_Callback(hObject, eventdata, handles)

global disc SubjectID xulv yulv xdlv ydlv Vahid hFH

Vahid=9;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

try 
    
    set(hFH,'Visible','off');

catch me

end

Zoom_FcnII(hObject, eventdata, handles)

if disc==1
    
    Vertebra_Upper_Line_Drawer_Fnc(hObject, eventdata, handles)
    
elseif disc==2
    
    try
        
        xulv=load([pwd,'\Archive\',SubjectID,'\xdln 1']);
        
        xulv=xulv.xdln;
        
        assignin('base','xulv',xulv);
        
        yulv=load([pwd,'\Archive\',SubjectID,'\ydln 1']);
        
        yulv=yulv.ydln;
        
        assignin('base','yulv',yulv);  
        
        xdlv=load([pwd,'\Archive\',SubjectID,'\xuln 2']);
        
        xdlv=xdlv.xuln;
        
        assignin('base','xdlv',xdlv);
        
        ydlv=load([pwd,'\Archive\',SubjectID,'\yuln 2']);
        
        ydlv=ydlv.yuln;
        
        assignin('base','ydlv',ydlv);
        
        Vertebra(hObject, eventdata, handles)
        
    catch me
        
        Vertebra_Upper_Line_Drawer_Fnc(hObject, eventdata, handles)
        
    end    
    
elseif disc==3
    
    try
        xulv=load([pwd,'\Archive\',SubjectID,'\xdln 2']);
        
        xulv=xulv.xdln;
        
        assignin('base','xulv',xulv);
        
        yulv=load([pwd,'\Archive\',SubjectID,'\ydln 2']);
        
        yulv=yulv.ydln;
        
        assignin('base','yulv',yulv);
        
        xdlv=load([pwd,'\Archive\',SubjectID,'\xuln 3']);
        
        xdlv=xdlv.xuln;
        
        assignin('base','xdlv',xdlv);
        
        ydlv=load([pwd,'\Archive\',SubjectID,'\yuln 3']);
        
        ydlv=ydlv.yuln;
        
        assignin('base','ydlv',ydlv);
        
        Vertebra(hObject, eventdata, handles)
        
    catch me
        
        Vertebra_Upper_Line_Drawer_Fnc(hObject, eventdata, handles)
        
    end
    
elseif disc==4
    
    try
        
        xulv=load([pwd,'\Archive\',SubjectID,'\xdln 3']);
        
        xulv=xulv.xdln;
        
        assignin('base','xulv',xulv);
        
        yulv=load([pwd,'\Archive\',SubjectID,'\ydln 3']);
        
        yulv=yulv.ydln;
        
        assignin('base','yulv',yulv);
        
        xdlv=load([pwd,'\Archive\',SubjectID,'\xuln 4']);
        
        xdlv=xdlv.xuln;
        
        assignin('base','xdlv',xdlv);
        
        ydlv=load([pwd,'\Archive\',SubjectID,'\yuln 4']);
        
        ydlv=ydlv.yuln;
        
        assignin('base','ydlv',ydlv);
        
        Vertebra(hObject, eventdata, handles)
        
    catch me
        
        Vertebra_Upper_Line_Drawer_Fnc(hObject, eventdata, handles)
        
    end
    
elseif disc==5
    
    try
        
        xulv=load([pwd,'\Archive\',SubjectID,'\xdln 4']);
        
        xulv=xulv.xdln;
        
        assignin('base','xulv',xulv);
        
        yulv=load([pwd,'\Archive\',SubjectID,'\ydln 4']);
        
        yulv=yulv.ydln;
        
        assignin('base','yulv',yulv);
        
        xdlv=load([pwd,'\Archive\',SubjectID,'\xuln 5']);
        
        xdlv=xdlv.xuln;
        
        assignin('base','xdlv',xdlv);
        
        ydlv=load([pwd,'\Archive\',SubjectID,'\yuln 5']);
        
        ydlv=ydlv.yuln;
        
        assignin('base','ydlv',ydlv);
        
        Vertebra(hObject, eventdata, handles)
        
    catch me
        
        Vertebra_Upper_Line_Drawer_Fnc(hObject, eventdata, handles)
        
    end    
end


function Vertebra(hObject, eventdata, handles)

global img hFH xulv yulv xdlv ydlv

xmin=round(xulv(1)-30);

xmax=round(xdlv(numel(xdlv))+30);

ymin=round(yulv(1)-30);

ymax=round(ydlv(numel(ydlv))+30);

set(gca,'XLim',[xmin,xmax],'YLim',[ymin,ymax]);

nl4s=numel(xulv);

nl4i=numel(xdlv);

smps=(((yulv(1)+yulv(nl4s))/2)-((ydlv(1)+ydlv(nl4i))/2))/(((xulv(1)+xulv(nl4s))/2)-((xdlv(1)+xdlv(nl4i))/2));

% Anterior wall 

set(gca,'XLim',[xulv(1)-70,xdlv(nl4i)+70],'YLim',[yulv(1)-70,ydlv(numel(ydlv))+70])

for i=1:100
    
	yawl4(i)=yulv(1)+4*(i-1); 
    
    if ge(yawl4(i),ydlv(1));yawl4(i)=[];break;end
    
    if le(xulv(1),xdlv(1))
        
        xmul(i)=(xulv(1)+(yawl4(i)-yulv(1))/smps)-5;
        
        xmur(i)=(xulv(1)+(yawl4(i)-yulv(1))/smps)+5;
        
    else
        
        xmul(i)=(xdlv(1)+(yawl4(i)-ydlv(1))/smps)-5;
        
        xmur(i)=(xdlv(1)+(yawl4(i)-ydlv(1))/smps)+5;
        
    end
    
    psp=improfile(img,[xmul(i) xmur(i)],[yawl4(i) yawl4(i)]);
    
    [~,lwsi(i)]=min(psp);
    
    xawl4(i)=xmul(i)+lwsi(i);   
    
end  

% Removing outliers

for i=2:numel(xawl4)-1
    
    if ge(xawl4(i),xawl4(i-1)+2)&&ge(xawl4(i),xawl4(i+1)+2)
        
        xawl4(i)=(xawl4(i-1)+xawl4(i-1))/2;
        
    end
    
end

for i=2:numel(xawl4)-1
    
    if le(xawl4(i),xawl4(i-1)-2)&&ge(xawl4(i),xawl4(i+1)-2)
        
        xawl4(i)=(xawl4(i-1)+xawl4(i+1))/2;
    end
    
end

% Posterior Wall

for i=1:100
    
	if ge(nl4i,nl4s)
        
        ypwl4(i)=ydlv(nl4s)-4*(i-1);
        
    else
        
        ypwl4(i)=ydlv(nl4i)-4*(i-1);
        
	end
    
    if le(ypwl4(i),yulv(nl4s))
        
        ypwl4(i)=[];
        
        break;
    
    end
    
    if ge(nl4i,nl4s)
        
        xmdl(i)=(xdlv(nl4s)+(ypwl4(i)-ydlv(nl4s))/smps)-5;
        
        xmdr(i)=(xdlv(nl4s)+(ypwl4(i)-ydlv(nl4s))/smps)+5;
        
    else
        
        xmdl(i)=(xdlv(nl4i)+(ypwl4(i)-ydlv(nl4i))/smps)-5;
        
        xmdr(i)=(xdlv(nl4i)+(ypwl4(i)-ydlv(nl4i))/smps)+5;
        
    end
    
    pip=improfile(img,[xmdl(i) xmdr(i)],[ypwl4(i) ypwl4(i)]);
    
    [~,rwsi(i)]=min(pip);xpwl4(i)=xmdl(i)+rwsi(i)-2;
    
end

% Removing outliers

for i=2:numel(xpwl4)-1
    
    if ge(xpwl4(i),xpwl4(i-1)+2)&&ge(xpwl4(i),xpwl4(i+1)+2)
        
        xpwl4(i)=(xpwl4(i-1)+xpwl4(i-1))/2;
    
    end

end

for i=2:numel(xpwl4)-1
    
    if le(xpwl4(i),xpwl4(i-1)-2)&&ge(xpwl4(i),xpwl4(i+1)-2)
        
        xpwl4(i)=(xpwl4(i-1)+xpwl4(i+1))/2;
    
    end

end

xroiv=round([xulv,fliplr(xpwl4),fliplr(xdlv),fliplr(xawl4)]);

yroiv=round([yulv,fliplr(ypwl4),fliplr(ydlv),fliplr(yawl4)]);

B=transpose([xroiv; yroiv]);

hFH=impoly(gca,B);

setColor(hFH,'y');

Edditing_Tool_Box_Keys_Off_Fcn(hObject, eventdata, handles)

answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');

switch answer
    
    case 'Yes'
        
        pushbutton17_Callback(hObject, eventdata, handles)
        
    case 'No'
        
        waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
        
        set(handles.pushbutton17,'visible','on');
        
end


function Vertebra_Upper_Line_Drawer_Fnc(hObject, eventdata, handles)

global img disc xulv yulv hFH xl1 xt12 yt12 yl1 xl2 yl2 xl3 yl3 xl4 yl4 xl5 yl5 

clc

clear xulv yulv

set(handles.pushbutton45,'visible','off');

Set_2nd_Measurement_Keys_Off_Fcn(hObject, eventdata, handles)

Naming_Vertebrae_Fcn(hObject, eventdata, handles)

if disc==1
    
    xmin=round(xt12-100);
    
    ymin=round(yt12);
    
    xmax=round(xl1+100);
    
    ymax=round(yl1);  
    
elseif disc==2
    
    xmin=round(xl1-100);
    
    ymin=round(yl1);
    
    xmax=round(xl2+100);
    
    ymax=round(yl2);  
    
elseif disc==3
    
    xmin=round(xl2-100);
    
    ymin=round(yl2);
    
    xmax=round(xl3+100);
    
    ymax=round(yl3); 
    
elseif disc==4
    
    xmin=round(xl3-100);
    
    ymin=round(yl3);
    
    xmax=round(xl4+100);
    
    ymax=round(yl4); 
    
elseif disc==5
    
    xmin=round(xl4-100);
    
    ymin=round(yl4);
    
    xmax=round(xl5+100);
    
    ymax=round(yl5);   
    
end   
set(gca,'XLim',[xmin,xmax],'YLim',[ymin,ymax]);

waitfor(warndlg('Please draw a line tangent to the superior endplate of the inferior vertebra!','MR Image Processing'));

c=getline(handles.axes1);   

xril=round(c(1,1));

yril=round(c(1,2));

xlil=round(c(2,1));

ylil=round(c(2,2));

m2=polyfit([xril xlil],[yril ylil],1);

nori=ceil(sqrt((xril-xlil).^2+(yril-ylil).^2));

for j=1:nori
    
	xdld(j)=xlil+(2*(j-1));
    
    if gt(xdld(j),xril)
        
        xdld(j)=[];
        
        break;
    
    end
    
    ydld(j)=m2(1,1)*xdld(j)+m2(1,2);
    
    if ge(j,floor(0.8*nori))
        
        ydlu(j)=ydld(j)-8;
        
    else
        
        ydlu(j)=ydld(j)-6;
        
    end
    
    xdlu(j)=xdld(j)+m2(1,1)*(ydld(j)-ydlu(j));
    
    [~,cdl(j)]=min(improfile(img,[xdlu(j) xdld(j)],[ydlu(j) ydld(j)]));
    
    ydpmi(j)=(ydlu(j)+cdl(j));
    
    xdpmi(j)=xdlu(j)-m2(1,1)*(ydpmi(j)-ydlu(j));
    
    for k=1:6
        
        ydpmax(k)=ydpmi(j)-(k-1);
        
        xdpmax(k)=xdpmi(j)-m2(1,1)*(ydpmax(k)-ydpmi(j));
        
        sipld(k)=improfile(img,xdpmax(k),ydpmax(k));
        
        if ge(k,2)
            
            dlpdh(k)=(sipld(k-1)-sipld(k));
        
        end
        
    end
    
    dlpdh(1)=[];
    
    [~,mdb2pd]=max(dlpdh);    
    
    xulv(j)=xdpmax(mdb2pd);
    
    yulv(j)=ydpmax(mdb2pd);  
    
end
B=transpose([xulv; yulv]);

hFH=impoly(gca,B,'Closed',false);

setColor(hFH,'r');

Edditing_Tool_Box_Keys_Off_Fcn(hObject, eventdata, handles)

set([handles.uipanel3,handles.pushbutton88,handles.pushbutton89],'visible','on');


% --- Executes on button press in redoing (pushbutton88).
function pushbutton88_Callback(hObject, eventdata, handles)

global hFH

try 
    
    set(hFH,'Visible','off')

catch me

end

Vertebra_Upper_Line_Drawer_Fnc(hObject, eventdata, handles)

% --- Executes on button press in confirming (pushbutton89).
function pushbutton89_Callback(hObject, eventdata, handles)

global hFH xulv yulv xdlv ydlv disc SubjectID

set([handles.uipanel3,handles.pushbutton88,handles.pushbutton89],'visible','off');

Coords=getPosition(hFH);

xulv=transpose(Coords(:,1));

assignin('base','xulv',xulv);

yulv=transpose(Coords(:,2));

assignin('base','yulv',yulv);

if disc==1
    
    xdlv=load([pwd,'\Archive\',SubjectID,'\xuln 1']);
    
    xdlv=xdlv.xuln;
    
    assignin('base','xdlv',xdlv);
    
    ydlv=load([pwd,'\Archive\',SubjectID,'\yuln 1']);
    
    ydlv=ydlv.yuln;
    
    assignin('base','ydlv',ydlv);
    
elseif disc==2
    
    xdlv=load([pwd,'\Archive\',SubjectID,'\xuln 2']);
    
    xdlv=xdlv.xuln;
    
    assignin('base','xdlv',xdlv);   
    
    ydlv=load([pwd,'\Archive\',SubjectID,'\yuln 2']);
    
    ydlv=ydlv.yuln;
    
    assignin('base','ydlv',ydlv);
    
elseif disc==3    
    
    xdlv=load([pwd,'\Archive\',SubjectID,'\xuln 3']);
    
    xdlv=xdlv.xuln;
    
    assignin('base','xdlv',xdlv);
    
    ydlv=load([pwd,'\Archive\',SubjectID,'\yuln 3']);
    
    ydlv=ydlv.yuln;
    
    assignin('base','ydlv',ydlv);

elseif disc==4
    
    xdlv=load([pwd,'\Archive\',SubjectID,'\xuln 4']);
    
    xdlv=xdlv.xuln;
    
    assignin('base','xdlv',xdlv);
    
    ydlv=load([pwd,'\Archive\',SubjectID,'\yuln 4']);
    
    ydlv=ydlv.yuln;
    
    assignin('base','ydlv',ydlv);

elseif disc==5
    
    xdlv=load([pwd,'\Archive\',SubjectID,'\xuln 5']);
    
    xdlv=xdlv.xuln;
    
    assignin('base','xdlv',xdlv);
    
    ydlv=load([pwd,'\Archive\',SubjectID,'\yuln 5']);
    
    ydlv=ydlv.yuln;
    
    assignin('base','ydlv',ydlv);

end

try 
    
    set(hFH,'Visible','off')

catch me

end

xdlv=evalin('base','xdlv');

ydlv=evalin('base','ydlv');

Vertebra(hObject, eventdata, handles)

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                             Recalling Data of the Previous or the Next Level
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function Recalling_Next_or_Previous_Level_Segmentation_Fcn(hObject, eventdata, handles)

global SubjectID disc

try
    load([pwd,'\Archive\',SubjectID,'\Disc Level ',num2str(disc)]); %#ok<*LOAD>
    
    assignin('base',['DROI',num2str(disc)],B);
    
    load([pwd,'\Archive\',SubjectID,'\xuln ',num2str(disc)]);
    
    assignin('base',['xul',num2str(disc)],B);
    
    load([pwd,'\Archive\',SubjectID,'\yuln ',num2str(disc)]);
    
    assignin('base',['yul',num2str(disc)],B);
    
    load([pwd,'\Archive\',SubjectID,'\xdln ',num2str(disc)]);
    
    assignin('base',['xdl',num2str(disc)],B);
    
    load([pwd,'\Archive\',SubjectID,'\ydln ',num2str(disc)]);
    
    assignin('base',['ydl',num2str(disc)],B);
    
    try
        
        load([pwd,'\Archive\',SubjectID,'\Nucleus Level ',num2str(disc)]);
        
        
        assignin('base',['NROI',num2str(disc)],B);
        
        
        set(handles.pushbutton69,'visible','on')
        
        
    catch me
        
    end
    
    try 
        
        load([pwd,'\Archive\',SubjectID,'\Ant Annulus Level ',num2str(disc)]);
        
        assignin('base',['AAROI',num2str(disc)],B);
        
        set(handles.pushbutton65,'visible','on')
        
    catch me
        
        set(handles.pushbutton33,'visible','on','BackgroundColor',[0 0.6 0])
        
    end
    
    try 
        
        load([pwd,'\Archive\',SubjectID,'\Post Annulus Level ',num2str(disc)]);
        
        assignin('base',['PAROI',num2str(disc)],B)
        
        set(handles.pushbutton64,'visible','on')
        
    catch me
        
        set(handles.pushbutton34,'visible','on','BackgroundColor',[0 0.6 0])
        
    end
    
    try 
        
        load([pwd,'\Archive\',SubjectID,'\Sup Fib Tissue Level ',num2str(disc)]);
        
        assignin('base',['SFTROI',num2str(disc)],B)
        
        set(handles.pushbutton63,'visible','on')
        
    catch me
        
        set(handles.pushbutton35,'visible','on','BackgroundColor',[0 0.6 0])
        
    end
    
    try 
        
        load([pwd,'\Archive\',SubjectID,'\Inf Fib Tissue Level ',num2str(disc)]);
        
        assignin('base',['IFTROI',num2str(disc)],B)
        
        set(handles.pushbutton62,'visible','on')
        
    catch me
        
        set(handles.pushbutton36,'visible','on','BackgroundColor',[0 0.6 0])
        
    end
    
    try
        
        load([pwd,'\Archive\',SubjectID,'\Sup Endplate Level ',num2str(disc)]);
        
        assignin('base',['SEROI',num2str(disc)],B)
        
        set(handles.pushbutton66,'visible','on')
        
    catch me
    end
    
    try
        
        load([pwd,'\Archive\',SubjectID,'\Inf Endplate Level ',num2str(disc)]);
        
        assignin('base',['IEROI',num2str(disc)],B)
        
        set(handles.pushbutton67,'visible','on')
        
    catch me
    end
    
    try
        
        load([pwd,'\Archive\',SubjectID,'\Vertebra ',num2str(disc)]);
        
        assignin('base',['VROI',num2str(disc)],B)
        
        set(handles.pushbutton61,'visible','on')
        
    catch me
        
    end
    
catch me
    
    Upper_Line_Drawer_Function(hObject, eventdata, handles)
    
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Recalling Archive Data
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function Recalling_Old_Segmentation_Fcn(hObject, eventdata, handles)

global SubjectID

for i=1:5   
    
    try
        
        load([pwd,'\Archive\',SubjectID,'\Disc Level ',num2str(i)]);
        
        assignin('base',['DROI',num2str(i)],B);
        
        load([pwd,'\Archive\',SubjectID,'\xuln ',num2str(i)]);
        
        assignin('base',['xul',num2str(i)],B);
        
        load([pwd,'\Archive\',SubjectID,'\yuln ',num2str(i)]);
        
        assignin('base',['yul',num2str(i)],B);
        
        load([pwd,'\Archive\',SubjectID,'\xdln ',num2str(i)]);
        
        assignin('base',['xdl',num2str(i)],B);
        
        load([pwd,'\Archive\',SubjectID,'\ydln ',num2str(i)]);
        
        assignin('base',['ydl',num2str(i)],B);
        
        load([pwd,'\Archive\',SubjectID,'\Nucleus Level ',num2str(i)]);
        
        assignin('base',['NROI',num2str(i)],B);
        
        try 
            
            load([pwd,'\Archive\',SubjectID,'\Ant Annulus Level ',num2str(i)]);
            
            assignin('base',['AAROI',num2str(i)],B);
        
        catch me
        
        end
        
        try 
            
            load([pwd,'\Archive\',SubjectID,'\Post Annulus Level ',num2str(i)]);
            
            assignin('base',['PAROI',num2str(i)],B);
        
        catch me
        
        end
        
        try 
            
            load([pwd,'\Archive\',SubjectID,'\Sup Fib Tissue Level ',num2str(i)]);
            
            assignin('base',['SFTROI',num2str(i)],B);
        
        catch me        
        
        end
        
        try 
            
            load([pwd,'\Archive\',SubjectID,'\Inf Fib Tissue Level ',num2str(i)]);
            
            assignin('base',['IFTROI',num2str(i)],B);
        
        catch me
        
        end
        
        try 
            
            load([pwd,'\Archive\',SubjectID,'\Sup Endplate Level ',num2str(i)]);
            
            assignin('base',['SEROI',num2str(i)],B);
        
        catch me
        
        end
        
        try 
            
            load([pwd,'\Archive\',SubjectID,'\Inf Endplate Level ',num2str(i)]);
            
            assignin('base',['IEROI',num2str(i)],B);
        
        catch me
        
        end
        
        try 
            
            load([pwd,'\Archive\',SubjectID,'\Vertebra ',num2str(i)]);
            
            assignin('base',['VROI',num2str(i)],B);
        
        catch me
        
        end
        
        if i==1
            
            set(handles.pushbutton8, 'Backgroundcolor', [0.00 0.60 0.00]);
            
        elseif i==2
            
            set(handles.pushbutton9, 'Backgroundcolor', [0.00 0.60 0.00]);
            
        elseif i==3
            
            set(handles.pushbutton10, 'Backgroundcolor', [0.00 0.60 0.00]);
            
        elseif i==4
            
            set(handles.pushbutton11, 'Backgroundcolor', [0.00 0.60 0.00]);
            
        else
            
            set(handles.pushbutton12, 'Backgroundcolor', [0.00 0.60 0.00]);
            
        end
        
    catch me
        
    end
    
end

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Disc
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% --- Executes on button press in disc (pushbutton68).
function pushbutton68_Callback(hObject, eventdata, handles)

global disc hFH SubjectID Shima Vahid

Shima = 1;

Vahid = Shima;

set([handles.uipanel6,handles.uipanel11],'visible','off');

String_Cleaner_Fcn(hObject, eventdata, handles)

set(handles.pushbutton17,'visible','on');

try 
    
    set(hFH,'Visible','off');

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

BDisc=load([pwd,'\Archive\',SubjectID,'\Disc Level ',num2str(disc)]);

hFH=impoly(gca,BDisc.B);

setColor(hFH,'g');

answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');

switch answer
    
    case 'Yes'
        
        pushbutton17_Callback(hObject, eventdata, handles)
        
    case 'No'
        
        waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
        
        set(handles.pushbutton17,'visible','on');
        
end

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Nucleus
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% --- Executes on button press in nucleus (pushbutton69).
function pushbutton69_Callback(hObject, eventdata, handles)

global disc hFH SubjectID Shima Vahid

Shima = 2;

Vahid = Shima;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

String_Cleaner_Fcn(hObject, eventdata, handles)

try 
    
    set(hFH,'Visible','off');


catch me

end

Zoom_FcnI(hObject, eventdata, handles)

try    
    BNucs=load([pwd,'\Archive\',SubjectID,'\Nucleus Level ',num2str(disc)]);    
    
    hFH=impoly(gca,BNucs.B);
    
    setColor(hFH,'g');
    
    answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');
    
    switch answer
        
        case 'Yes'
            
            pushbutton17_Callback(hObject, eventdata, handles)
            
        case 'No'
            
            waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
            
            set(handles.pushbutton17,'visible','on');
            
    end
    
catch me
    
    Upper_Line_Drawer_Function(hObject, eventdata, handles)
    
end

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Anterior Annulus
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% --- Executes on button press in anterior annulus (pushbutton65).
function pushbutton65_Callback(hObject, eventdata, handles)

global disc hFH SubjectID Shima Vahid

Shima = 3;

Vahid = Shima;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

String_Cleaner_Fcn(hObject, eventdata, handles)

try 
    
    set(hFH,'Visible','off');

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

try    
    
    BAA=load([pwd,'\Archive\',SubjectID,'\Ant Annulus Level ',num2str(disc)]);   
    
    hFH=impoly(gca,BAA.B);
    
    setColor(hFH,'g');
    
    answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');
    
    switch answer
        
        case 'Yes'
            
            pushbutton17_Callback(hObject, eventdata, handles)
            
        case 'No'
            
            waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
            
            set(handles.pushbutton17,'visible','on');
            
    end
    
catch me
    
    pushbutton33_Callback(hObject, eventdata, handles)
    
    set(handles.pushbutton34,'Enable','on');
    
end

set(handles.pushbutton35,'Enable','on');

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Posterior Annulus
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% --- Executes on button press in posterior annulus (pushbutton64).
function pushbutton64_Callback(hObject, eventdata, handles)

global disc hFH SubjectID Shima Vahid

Shima = 4;

Vahid = Shima;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

String_Cleaner_Fcn(hObject, eventdata, handles)

try 
    
    set(hFH,'Visible','off')

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

try    
    
    BPA=load([pwd,'\Archive\',SubjectID,'\Post Annulus Level ',num2str(disc)]);    
    
    hFH=impoly(gca,BPA.B);
    
    setColor(hFH,'g');
    
    answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');
    
    switch answer
        
        case 'Yes'
            
            pushbutton17_Callback(hObject, eventdata, handles)
            
        case 'No'
            
            waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
            
            set(handles.pushbutton17,'visible','on');
            
    end
    
catch me
    
    pushbutton34_Callback(hObject, eventdata, handles)
    
    set(handles.pushbutton35,'Enable','on');
    
end

set(handles.pushbutton36,'Enable','on');

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Superior Fibrous Tissue
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% --- Executes on button press in  superior fibrous tissue (pushbutton63).
function pushbutton63_Callback(hObject, eventdata, handles)

global disc hFH SubjectID Shima Vahid

Shima = 5;

Vahid = Shima;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

String_Cleaner_Fcn(hObject, eventdata, handles)

try 
    
    set(hFH,'Visible','off');

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

try    
    
    BSFT=load([pwd,'\Archive\',SubjectID,'\Sup Fib Tissue Level ',num2str(disc)]);  
    
    hFH=impoly(gca,BSFT.B);
    
    setColor(hFH,'g');
    
    answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');
    
    switch answer
        
        case 'Yes'
            
            pushbutton17_Callback(hObject, eventdata, handles)
            
        case 'No'
            
            waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
            
            set(handles.pushbutton17,'visible','on');
            
    end
    
catch me
    
    pushbutton35_Callback(hObject, eventdata, handles)
    
    set(handles.pushbutton36,'Enable','on');
    
end

set(handles.pushbutton37,'Enable','on');


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Inferior Fibrous Tissue
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in inferior fibrous tissue (pushbutton62).
function pushbutton62_Callback(hObject, eventdata, handles)

global disc hFH SubjectID Shima Vahid

Shima = 6;

Vahid = Shima;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

String_Cleaner_Fcn(hObject, eventdata, handles)

try 
    
    set(hFH,'Visible','off');

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

try    
    
    BIFT=load([pwd,'\Archive\',SubjectID,'\Inf Fib Tissue Level ',num2str(disc)]);  
    
    hFH=impoly(gca,BIFT.B);
    
    setColor(hFH,'g');
    
    answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');
    
    switch answer
        
        case 'Yes'
            
            pushbutton17_Callback(hObject, eventdata, handles)
            
        case 'No'
            
            waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
            
            set(handles.pushbutton17,'visible','on');
            
    end
    
catch me
    
    pushbutton36_Callback(hObject, eventdata, handles)
    
    set(handles.pushbutton37,'Enable','on');
    
end

set(handles.pushbutton37,'Enable','on');

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Superior Endplate
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% --- Executes on button press in superior endplate (pushbutton66).
function pushbutton66_Callback(hObject, eventdata, handles)

global disc hFH SubjectID Shima Vahid

Shima = 7;

Vahid = Shima;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

String_Cleaner_Fcn(hObject, eventdata, handles)

try 
    
    set(hFH,'Visible','off')

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

try    
    
    BSE=load([pwd,'\Archive\',SubjectID,'\Sup Endplate Level ',num2str(disc)]);   
    
    hFH=impoly(gca,BSE.B);
    
    setColor(hFH,'g');
    
    answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');
    
    switch answer
        
        case 'Yes'
            
            pushbutton17_Callback(hObject, eventdata, handles)
            
        case 'No'
            
            waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
            
            set(handles.pushbutton17,'visible','on');
            
    end
    
catch me
    
    pushbutton37_Callback(hObject, eventdata, handles)
    
end

set(handles.pushbutton38,'Enable','on');


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Inferior Endplate 
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in inferior endplate (pushbutton67).
function pushbutton67_Callback(hObject, eventdata, handles)

global disc hFH SubjectID Shima Vahid

Shima = 8;

Vahid = Shima;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11],'visible','off');

String_Cleaner_Fcn(hObject, eventdata, handles)

try 
    set(hFH,'Visible','off')

catch me

end

Zoom_FcnI(hObject, eventdata, handles)

try    
    
    BIE=load([pwd,'\Archive\',SubjectID,'\Inf Endplate Level ',num2str(disc)]);  
    
    hFH=impoly(gca,BIE.B);
    
    setColor(hFH,'g');
    
    answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');
    
    switch answer
        
        case 'Yes'
            
            pushbutton17_Callback(hObject, eventdata, handles)
            
        case 'No'
            
            waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
            
            set(handles.pushbutton17,'visible','on');
            
    end
    
catch me
    
    pushbutton38_Callback(hObject, eventdata, handles)
    
end

if disc==1
    
    set([handles.pushbutton45,handles.pushbutton61],'Enable','off');
    
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Vertebra
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in vertebra (pushbutton61).
function pushbutton61_Callback(hObject, eventdata, handles)

global disc hFH SubjectID Shima Vahid

Shima = 9;

Vahid = Shima;

set([handles.pushbutton17,handles.uipanel6,handles.uipanel11,handles.pushbutton33,handles.pushbutton34,...
    handles.pushbutton35,handles.pushbutton36,handles.pushbutton37,handles.pushbutton38,handles.pushbutton45],'visible','off');

String_Cleaner_Fcn(hObject, eventdata, handles)

try 
    
    set(hFH,'Visible','off')

catch me

end

Zoom_FcnII(hObject, eventdata, handles)

try
    
    BV=load([pwd,'\Archive\',SubjectID,'\Vertebra ',num2str(disc)]); 
    
    hFH=impoly(gca,BV.B);
    
    setColor(hFH,'g');
    
    answer=questdlg('Do you like the drawn ROI?','Spine GUI','Yes','No','Yes');
    
    switch answer
        
        case 'Yes'
            
            pushbutton17_Callback(hObject, eventdata, handles)
            
        case 'No'
            
            waitfor(msgbox({'Please modify the ROI and then hit the “Measure” key!'},'Spine GUI'));
            
            set(handles.pushbutton17,'visible','on');
            
    end
    
catch me
    
    pushbutton45_Callback(hObject, eventdata, handles)
    
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Calculating & Saving Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function T2MapperFcn(hObject, eventdata, handles)

global hFH imgmap T2sol

clc

h = waitbar(0, 'Calculating the T2-map','Name', 'Spine Analyser');

evalin('base', 'clear pval* T2sol S0sol TE_ms')

a = hFH.createMask();

img = evalin('base', 'img');

ROI_PixelList = regionprops(a, img, {'PixelList', 'PixelValue'});

ROIPL= ROI_PixelList.PixelList;

XROI = ROIPL(:,1);

YROI = ROIPL(:,2);

NOIITF = numel(dir([pwd, '\Images\Have not been analyzed\UL*']));

for i = 1:NOIITF
    
    img4M = dicomread([pwd, '\Images\Have not been analyzed\UL', num2str(i)]);
    
    DIIinfoa = dicominfo([pwd, '\Images\Have not been analyzed\UL', num2str(i)]);
    
    TE_ms(i) = DIIinfoa.EchoTime;   
    
    for j = 1:numel(YROI)
        
        picvalue(j) = transpose(double(img4M(YROI(j), XROI(j))));
        
    end
    
    pval{i} = transpose(picvalue);
    
    h = waitbar(i*0.10, h, 'Calculating the T2-map', 'Name', 'Spine Analyser');
    
end
s = cell2mat(pval);

T2sol = zeros(size(s(:, 1)));

S0sol = zeros(size(s(:, 1)));

solve_mask = ones(size(s(:, 1)));

f = @(x, S)sqrt(sum((S-x(1).*exp(-TE_ms./x(2))).^2));

options = optimset('MaxFunEvals', 1000, 'MaxIter', 1000);

mod_size = max([ceil(numel(T2sol)*0.02) 2]);

for n = 1:size(s, 1)
    
    S  =s(n,:);
    
    S0init = S(1)*(S(1)/S(end))^(TE_ms(1)/(TE_ms(end)-TE_ms(1))); %#ok<*COLND>
    
    T2init = -(TE_ms(end)-TE_ms(1))/log(S(end)/S(1));
    
    if T2init>3000||T2init<=0||isnan(T2init)
        
        T2init = 3000;
        
    end    
    
    [X,fval,exitflag] = fminsearch(@(x)f(x, S), [S0init;T2init], options); %#ok<*ASGLU>
    
    if exitflag == 1&&X(2)>0&&X(2)<5000&&~isnan(X(2)) 
        
        T2sol(n) = X(2);
        
        S0sol(n) = X(1);
        
    else
        
        solve_mask(n) = 0;
        
    end
end

h = waitbar(0.5, h, 'Calculating the T2-map', 'Name', 'Spine Analyser');

imgsize = size(img);

ROI = zeros(imgsize(:, 1),imgsize(:, 2));

ROI(YROI(1):YROI(numel(YROI)), XROI(1):XROI(numel(XROI))) = 1;% temporary ROI 

New_ROI = uint16(zeros(imgsize(:, 1),imgsize(:, 2)));% new ROI for new intensities 

t = 0;

for i = 1:size(T2sol)
    
    ix = YROI(i);
    
    iy = XROI(i);
    
    intens = T2sol(i);
    
    New_ROI(ix,iy) = intens;
    
end

I = img;

for i = 1:imgsize(:, 1)
    
    for j = 1:imgsize(:, 1)
        
        if New_ROI(i, j) == 0
            
            I(i, j) = 0;
        
        end
        
    end
    
end

axes(handles.axes5);

assignin('base', 's', s)

xmin = min(YROI) - 5;

ymin = min(XROI) - 5;

xmax = max(YROI) + 5;

ymax = max(XROI) + 5;

set(handles.uipanel11, 'visible', 'on')

I_roi = I(xmin:xmax, ymin:ymax);

h_img2 = imshow(I_roi, []);

colormap(handles.axes5, 'hot')

imgmap = New_ROI;

axes(handles.axes1)

close(h)


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Calculating the Results
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in disc measurement (pushbutton17).
function pushbutton17_Callback(hObject, eventdata, handles)

global hFH imgmap Joubin disc T2sol SubjectID Vahid Shima

clc

mkdir([pwd, '\Archive\', num2str(SubjectID)]);

set(handles.pushbutton17, 'visible', 'off');

String_Cleaner_Fcn(hObject, eventdata, handles)

set(handles.uipanel6, 'visible', 'on');

a = hFH.createMask();

if Joubin == 1
    
    T2MapperFcn(hObject, eventdata, handles);
    
    statistvector(1) = mean2(T2sol);
    
    rstatistvector(1) = round(statistvector(1));
    
    set(handles.edit3, 'String', num2str(rstatistvector(1)));
    
    statistvector(2) = std2(T2sol);
    
    statistvector(3) = (statistvector(2)/statistvector(1))*100;
    
    set(handles.edit4, 'String', num2str(statistvector(3)));
    
    statistvector(4) = max(T2sol);
    
    statistvector(5) = min(T2sol);
    
    statistvector(6) = statistvector(4) - statistvector(5);
    
    statistvector(7) = kurtosis(T2sol);
    
    set(handles.edit6, 'String', num2str(statistvector(7)));  
    
    statistvector(8) = skewness(T2sol);
    
    set(handles.edit7, 'String', num2str(statistvector(8))); 
    
    ROIrp = regionprops(a, imgmap, {'Centroid','WeightedCentroid','Area'});
    
    assignin('base', 'ROIrp', ROIrp)
    
else
    
    imgmap = evalin('base','img');
    
    statistvector(1) = mean2(imgmap(a));
    
    rstatistvector(1) = round(statistvector(1));
    
    set(handles.edit3, 'String', num2str(rstatistvector(1)));
    
    statistvector(2) = std2(imgmap(a));
    
    statistvector(3) = (statistvector(2)/statistvector(1))*100;
    
    set(handles.edit4, 'String', num2str(statistvector(3)));
    
    ROIrp = regionprops(a, imgmap,{'Centroid', 'WeightedCentroid', 'Area', 'MinIntensity', 'MaxIntensity', 'PixelValues'});
    
    assignin('base', 'ROIrp', ROIrp)
    
    statistvector(4) = ROIrp.MaxIntensity;
    
    statistvector(5) = ROIrp.MinIntensity;
    
    statistvector(6) = statistvector(4) - statistvector(5);
    
    ImageIV = double(ROIrp.PixelValues);
    
    statistvector(7) = kurtosis(ImageIV);
    
    set(handles.edit6, 'String', num2str(statistvector(7))); 
    
    statistvector(8) = skewness(ImageIV);
    
    set(handles.edit7, 'String', num2str(statistvector(8))); 
    
end

statistvector(9) = ROIrp.Area;

rWIar = round(statistvector(9));

set(handles.edit5, 'String', num2str(rWIar));   

ROIcd = ROIrp.Centroid;

rWIcd = round(ROIcd);

set(handles.edit8, 'String', num2str(rWIcd));

statistvector(10) = ROIrp.Centroid(1, 1);

statistvector(11) = ROIrp.Centroid(1, 2);

WROwcd = ROIrp.WeightedCentroid;

rWIwcd = round(WROwcd);

set(handles.edit9, 'String', num2str(rWIwcd));

statistvector(12) = ROIrp.WeightedCentroid(1, 1);

statistvector(13) = ROIrp.WeightedCentroid(1, 2);

%  [0 1] is the pixel next to the pixel of interest

offsets = [0 1; 0 2; 0 3; 0 4; -1 1; -2 2; -3 3; -4 4;
    -1 0; -2 0; -3 0; -4 0; -1 -1; -2 -2; -3 -3; -4 -4; 
    0 -1; 0 -2; 0 -3; 0 -4;  1 -1; 2 -2; 3 -3; 4 -4;  
    1 0; 2 0; 3 0; 4 0; 1 1; 2 2; 3 3; 4 4];

glcm = graycomatrix(a, 'Offset', offsets);

stats = struct2cell(Texture_Features(glcm, 0));

assignin('base', 'stats', stats)

for i = 1:numel(stats)
    
    if i == 2
        
        roicont = stats{i,1}*1000;
        
        set(handles.edit13,'String',num2str(roicont(1,1)));
        
    elseif i == 3
        
        roicor = stats{i,1};
        
        set(handles.edit11,'String',num2str(roicor(1,1)));
        
    elseif i == 8
        
        roieng = stats{i,1};
        
        set(handles.edit12,'String',num2str(roieng(1,1)));
        
    elseif i == 10
        
        roihomo = stats{i,1};
        
        set(handles.edit10,'String',num2str(roihomo(1,1)));
        
    end
    
end

Coords = getPosition(hFH);

xroid = transpose(Coords(:, 1));

yroid = transpose(Coords(:, 2));

B = transpose([xroid; yroid]);

if Vahid == 1 || Shima == 1
    
    save([pwd, '\Archive\', SubjectID, '\Disc Level ', num2str(disc)], 'B')
    
    Saeid = ['Disc ', num2str(disc)];
    
elseif Vahid == 2 || Shima == 2
    
    save([pwd, '\Archive\', SubjectID, '\Nucleus Level ', num2str(disc)],'B')
    
    Saeid = ['Nucleus ', num2str(disc)];
    
elseif Vahid == 3 || Shima == 3
    
    save([pwd, '\Archive\', SubjectID, '\Ant Annulus Level ', num2str(disc)], 'B')
    
    Saeid = ['AA ', num2str(disc)];
    
elseif Vahid == 4 || Shima == 4
    
    save([pwd, '\Archive\', SubjectID, '\Post Annulus Level ', num2str(disc)], 'B')
    
    Saeid = ['PA ', num2str(disc)];
    
elseif Vahid == 5 || Shima == 5
    
    save([pwd, '\Archive\', SubjectID, '\Sup Fib Tissue Level ', num2str(disc)], 'B')
    
    Saeid = ['SFT ', num2str(disc)];
    
elseif Vahid == 6 || Shima == 6
    
    save([pwd, '\Archive\', SubjectID, '\Inf Fib Tissue Level ', num2str(disc)], 'B')
    
    Saeid = ['IFT ', num2str(disc)];
    
elseif Vahid == 7 || Shima == 7
    
    save([pwd, '\Archive\', SubjectID, '\Sup Endplate Level ', num2str(disc)], 'B')
    
    Saeid = ['SEP ', num2str(disc)];
    
elseif Vahid == 8 || Shima == 8
    
    save([pwd,'\Archive\',SubjectID,'\Inf Endplate Level ',num2str(disc)],'B')
    
    Saeid = ['IEP ', num2str(disc)];
    
elseif Vahid == 9 || Shima == 9
    
    save([pwd, '\Archive\', SubjectID, '\Vertebra ', num2str(disc)], 'B')
    
    Saeid = ['Vertebra ', num2str(disc)];
    
end

answer = questdlg('Do you want to save the results?','Spine GUI','Yes','No','Yes');

switch answer
    
    case 'Yes'
        
        h=waitbar(0,'Saving the results','Name','Spine Analyser');
        
        SubID=SubjectID(8:end);
        
        SubID=strrep(SubID,', KW',[]);
        
        mkdir([pwd,'\Results\Texture']);
        
        xlswrite([pwd,'\Results\First Order Statistics.xlsx'],{'Mean','St. Dev','Coeff of Variation','Maximum','Minimum',...
            'Range','Kurtosis','Skewness','Area','Weighted Centroid','','SI Weighted Centroid'},Saeid,'A1');
        
        xlswrite([pwd,'\Results\First Order Statistics.xlsx'],statistvector,Saeid,strcat('A',num2str(str2num(SubID)+1)));
        
        h=waitbar(0.5,h,'Saving the results','Name','Spine Analyser');
        
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'],...
            transpose({'Autocorrelation','Contrast','Correlation (Matlab Based)','Correlation',...
                    'Cluster Prominence','Cluster Shade','Dissimilarity','Energy Matlab Based','Entropy',...
                    'Homogeneity (Matlab Based)','Homogeneity','Maximum Probability','Variance of the Sum of Squares',...
                    'Sum Average','Sum Variance','Sum Entropy','Difference Variance','Difference Entropy',...
                    'Information Measure of Correlation 1','Information Measure of Correlation 2',...
                    'Inverse Difference Normalised','Inverse Difference Moment Normalised'}),Saeid,'A3');
                
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'0 Degree Direction'}, Saeid,'E1');
                
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'45 Degree Direction'}, Saeid,'I1');
                
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'90 Degree Direction'}, Saeid,'M1');
                
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'135 Degree Direction'}, Saeid,'Q1');
                
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'180 Degree Direction'}, Saeid,'U1');
                
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'225 Degree Direction'}, Saeid,'Y1');
                
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'270 Degree Direction'}, Saeid,'AC1');
                
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'315 Degree Direction'}, Saeid,'AG1');
        
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'Sum'}, Saeid,'Ak1'); 
        
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'Means'}, Saeid,'AO1'); 
        
        xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'],...
            {'1-OFST','2-OFST','3-OFST','4-OFST',... % 0 Degree
            '1-OFST','2-OFST','3-OFST','4-OFST',... % 45 Degree
            '1-OFST','2-OFST','3-OFST','4-OFST',... % 90 Degree
            '1-OFST','2-OFST','3-OFST','4-OFST',... % 135 Degree
            '1-OFST','2-OFST','3-OFST','4-OFST',... % 180 Degree
            '1-OFST','2-OFST','3-OFST','4-OFST',... % 225 Degree
            '1-OFST','2-OFST','3-OFST','4-OFST',... % 270 Degree
            '1-OFST','2-OFST','3-OFST','4-OFST',... % 315 Degree
            '1-OFST','2-OFST','3-OFST','4-OFST',... % Sum
            '1-OFST','2-OFST','3-OFST','4-OFST'},... % Means
            Saeid,'E2');
        
        for n = 1 : numel(stats)
    
            SV(n,:) = stats{n, 1};

        end

        for n = 1 : numel(stats)

            TP1 (n, :) = SV(n, 1) + SV(n, 5) + SV(n, 9) + SV(n, 13) + SV(n, 17) + SV(n, 21) + SV(n, 25) + SV(n, 29);

            TP2 (n, :) = SV(n, 2) + SV(n, 6) + SV(n, 10) + SV(n, 14) + SV(n, 18) + SV(n, 22) + SV(n, 26) + SV(n, 30);

            TP3 (n, :) = SV(n, 3) + SV(n, 7) + SV(n, 11) + SV(n, 15) + SV(n, 19) + SV(n, 23) + SV(n, 27) + SV(n, 31);

            TP4 (n, :) = SV(n, 4) + SV(n, 8) + SV(n, 12) + SV(n, 16) + SV(n, 20) + SV(n, 24) + SV(n, 28) + SV(n, 32);    

        end

        TP = [TP1, TP2, TP3, TP4];

        MTP = TP/8;
        
        xlswrite([pwd, '\Results\Texture\Subject ', num2str(SubID), '.xlsx'], cell2mat(stats), Saeid, 'E3');
        
        xlswrite([pwd, '\Results\Texture\Subject ', num2str(SubID), '.xlsx'], TP, Saeid, 'AK3');
        
        xlswrite([pwd, '\Results\Texture\Subject ', num2str(SubID), '.xlsx'], MTP, Saeid, 'AO3');
        
        waitbar(1,h,'Saving the results completed.','Name','Spine Analyser');
        
        close(h)
        
    case 'No' 
        
        answer=questdlg('Are you sure that you do not want to save the results!','Spine GUI','Yes','No','No');
        
        switch answer
            
            case 'Yes'
                
                waitfor(warndlg({'The results were not saved!'},'Spine GUI'));
                
            case 'No'
                
                h=waitbar(0,'Saving the results','Name','Spine Analyser');
                
                SubID=SubjectID(8:end);SubID=strrep(SubID,', KW',[]);
                
                mkdir([pwd,'\Results\Texture']);
                
                xlswrite([pwd,'\Results\First Order Statistics.xlsx'],{'Mean','St. Dev','Coeff of Variation','Maximum','Minimum',...
                    'Range','Kurtosis','Skewness','Area','Weighted Centroid','','SI Weighted Centroid'},Saeid,'A1');
                
                xlswrite([pwd,'\Results\First Order Statistics.xlsx'],statistvector,Saeid,strcat('A',num2str(str2num(SubID)+1)));
                h=waitbar(0.5,h,'Saving the results','Name','Spine Analyser');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'],...
                    transpose({'Autocorrelation','Contrast','Correlation (Matlab Based)','Correlation',...
                    'Cluster Prominence','Cluster Shade','Dissimilarity','Energy Matlab Based','Entropy',...
                    'Homogeneity (Matlab Based)','Homogeneity','Maximum Probability','Variance of the Sum of Squares',...
                    'Sum Average','Sum Variance','Sum Entropy','Difference Variance','Difference Entropy',...
                    'Information Measure of Correlation 1','Information Measure of Correlation 2',...
                    'Inverse Difference Normalised','Inverse Difference Moment Normalised'}),Saeid,'A3');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'0 Degree Direction'}, Saeid,'E1');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'45 Degree Direction'}, Saeid,'I1');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'90 Degree Direction'}, Saeid,'M1');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'135 Degree Direction'}, Saeid,'Q1');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'180 Degree Direction'}, Saeid,'U1');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'225 Degree Direction'}, Saeid,'Y1');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'270 Degree Direction'}, Saeid,'AC1');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'315 Degree Direction'}, Saeid,'AG1');
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'Sum'}, Saeid,'Ak1');
        
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'], {'Means'}, Saeid,'AO1'); 
                
                xlswrite([pwd,'\Results\Texture\Subject ',num2str(SubID),'.xlsx'],...
                    {'1-OFST','2-OFST','3-OFST','4-OFST',... % 0 Degree
                    '1-OFST','2-OFST','3-OFST','4-OFST',... % 45 Degree
                    '1-OFST','2-OFST','3-OFST','4-OFST',... % 90 Degree
                    '1-OFST','2-OFST','3-OFST','4-OFST',... % 135 Degree
                    '1-OFST','2-OFST','3-OFST','4-OFST',... % 180 Degree
                    '1-OFST','2-OFST','3-OFST','4-OFST',... % 225 Degree
                    '1-OFST','2-OFST','3-OFST','4-OFST',... % 270 Degree
                    '1-OFST','2-OFST','3-OFST','4-OFST',... % 315 Degree
                    '1-OFST','2-OFST','3-OFST','4-OFST',... % Sum
                    '1-OFST','2-OFST','3-OFST','4-OFST'},... % Means
                    Saeid,'E2');
                
                for n = 1 : numel(stats)
    
                    SV(n,:) = stats{n, 1};

                end

                for n = 1 : numel(stats)

                    TP1 (n, :) = SV(n, 1) + SV(n, 5) + SV(n, 9) + SV(n, 13) + SV(n, 17) + SV(n, 21) + SV(n, 25) + SV(n, 29);

                    TP2 (n, :) = SV(n, 2) + SV(n, 6) + SV(n, 10) + SV(n, 14) + SV(n, 18) + SV(n, 22) + SV(n, 26) + SV(n, 30);

                    TP3 (n, :) = SV(n, 3) + SV(n, 7) + SV(n, 11) + SV(n, 15) + SV(n, 19) + SV(n, 23) + SV(n, 27) + SV(n, 31);

                    TP4 (n, :) = SV(n, 4) + SV(n, 8) + SV(n, 12) + SV(n, 16) + SV(n, 20) + SV(n, 24) + SV(n, 28) + SV(n, 32);    

                end

                TP = [TP1, TP2, TP3, TP4];

                MTP = TP/8;

                xlswrite([pwd, '\Results\Texture\Subject ', num2str(SubID), '.xlsx'], cell2mat(stats), Saeid, 'E3');

                xlswrite([pwd, '\Results\Texture\Subject ', num2str(SubID), '.xlsx'], TP, Saeid, 'AK3');

                xlswrite([pwd, '\Results\Texture\Subject ', num2str(SubID), '.xlsx'], MTP, Saeid, 'AO3');

                waitbar(1,h,'Saving the results completed.','Name','Spine Analyser');

                close(h)

        end
        
end

set([handles.uipanel3, handles.pushbutton17], 'visible', 'off')

set([handles.pushbutton14, handles.pushbutton15], 'visible', 'on')

if Vahid==1
    
    set([handles.pushbutton68,handles.pushbutton30,handles.pushbutton33,handles.pushbutton34,handles.pushbutton35,handles.pushbutton36,...
        handles.pushbutton37,handles.pushbutton38,handles.pushbutton45],'visible','on')
    
elseif Vahid==2
    
    set(handles.pushbutton30,'visible','off')
    
    set([handles.pushbutton68,handles.pushbutton69,handles.pushbutton33,handles.pushbutton34,handles.pushbutton35,handles.pushbutton36,...
        handles.pushbutton37,handles.pushbutton38,handles.pushbutton45],'visible','on')
    
    set([handles.pushbutton33,handles.pushbutton45],'enable','on')
    
elseif Vahid==3
    
    set(handles.pushbutton33,'visible','off')
    
    set([handles.pushbutton68,handles.pushbutton69,handles.pushbutton65,handles.pushbutton34,handles.pushbutton35,handles.pushbutton36,...
        handles.pushbutton37,handles.pushbutton38,handles.pushbutton45],'visible','on')
    
    set(handles.pushbutton34,'enable','on')
    
elseif Vahid==4
    
    set(handles.pushbutton34,'visible','off')
    
    set([handles.pushbutton68,handles.pushbutton69,handles.pushbutton65,handles.pushbutton64,handles.pushbutton35,handles.pushbutton36,...
        handles.pushbutton37,handles.pushbutton38,handles.pushbutton45],'visible','on')
    
    set(handles.pushbutton35,'enable','on')

elseif Vahid==5
    
    set(handles.pushbutton35,'visible','off')
    
    set([handles.pushbutton68,handles.pushbutton69,handles.pushbutton65,handles.pushbutton64,handles.pushbutton63,handles.pushbutton36,...
        handles.pushbutton37,handles.pushbutton38,handles.pushbutton45],'visible','on')
    
    set(handles.pushbutton36,'enable','on')

elseif Vahid==6
        
    set(handles.pushbutton36,'visible','off')
    
    set([handles.pushbutton68,handles.pushbutton69,handles.pushbutton65,handles.pushbutton64,handles.pushbutton63,handles.pushbutton62,...
        handles.pushbutton37,handles.pushbutton38,handles.pushbutton45],'visible','on')
    
    set(handles.pushbutton37,'enable','on')

elseif Vahid==7
    
    set(handles.pushbutton37,'visible','off')
    
    set([handles.pushbutton68,handles.pushbutton69,handles.pushbutton65,handles.pushbutton64,handles.pushbutton63,handles.pushbutton62,...
        handles.pushbutton66,handles.pushbutton38,handles.pushbutton45],'visible','on')
    
    set(handles.pushbutton38,'enable','on')

elseif Vahid==8
    
    set(handles.pushbutton38,'visible','off')
    
    set([handles.pushbutton68,handles.pushbutton69,handles.pushbutton65,handles.pushbutton64,handles.pushbutton63,handles.pushbutton62,...
        handles.pushbutton66,handles.pushbutton67,handles.pushbutton45],'visible','on')    

elseif Vahid==9
    
    set(handles.pushbutton45,'visible','off')
    
    set([handles.pushbutton68,handles.pushbutton69,handles.pushbutton65,handles.pushbutton64,handles.pushbutton63,handles.pushbutton62,...
        handles.pushbutton66,handles.pushbutton67,handles.pushbutton61],'visible','on')

    if ge(Shima,1)
        
        set([handles.pushbutton68,handles.pushbutton69,handles.pushbutton65,handles.pushbutton64,handles.pushbutton63,handles.pushbutton62,...
            handles.pushbutton66,handles.pushbutton67,handles.pushbutton61],'visible','on') 

    end
    
end


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Saving the Results
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes on button press in saving data(pushbutton16).
function pushbutton16_Callback(hObject, eventdata, handles)

pushbutton17_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                           Support Section
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function Edditing_Tool_Box_Keys_Off_Fcn(hObject, eventdata, handles)

set([handles.pushbutton18,handles.pushbutton19,handles.pushbutton20,handles.pushbutton21,handles.pushbutton25,handles.pushbutton26,...
    handles.pushbutton28,handles.pushbutton55,handles.pushbutton56,handles.pushbutton88,handles.pushbutton89,...
    handles.pushbutton27],'visible','off')

function Angle_Calculator_Fcn(hObject, eventdata, handles)

global img xdln ydln xuln yuln m1 m2 m3 xs ys xe ye xlsl xlil xrsl xril

m1=polyfit(xuln,yuln,1);

m2=polyfit(xdln,ydln,1);

m3=(m1(1,1)+m2(1,1))/2;

xl=(xuln(1)+xdln(1))/2;

yl=(yuln(1)+ydln(1))/2; 

xr=(xuln(numel(xuln))+xdln(numel(xdln)))/2;

yr=(yuln(numel(yuln))+ydln(numel(ydln)))/2;

for i=1:10
    
	if ge(xlsl,xlil)
        
        xls(i)=xlsl-i;
        
    else
        
        xls(i)=xlil-i;
        
	end
    
    yls(i)=m3*(xls(i)-xl)+yl;
    
    sipdp(i)=improfile(img,xls(i),yls(i));
    
    if ge(i,2)
        
        dlp(i)=sipdp(i)-sipdp(i-1);
    
    end
    
end

dlp(1)=[];[~,msil]=max(dlp);

xs=xl-msil;

ys=m3*(xs-xl)+yl;

for i=1:10
    
	if ge(xrsl,xril)
        
        xrs(i)=xrsl+i;
        
    else
        
        xrs(i)=xril+i;
        
	end
    
    yrs(i)=m3*(xrs(i)-xr)+yr;
    
    sipdp(i)=improfile(img,xrs(i),yrs(i));
    
	if ge(i,2)
        
        dlp(i)=sipdp(i)-sipdp(i-1);
    
	end        
end

dlp(1)=[];

[~,msil]=max(dlp);

xe=xr+msil;

ye=m3*(xe-xr)+yr;


function Set_Selection_Handels_On_Fcn(hObject, eventdata, handles)
set([handles.text5,handles.pushbutton8,handles.pushbutton9,handles.pushbutton10,handles.pushbutton11,handles.pushbutton12],'visible','on');

Recalling_Old_Segmentation_Fcn(hObject, eventdata, handles)


function Set_Selection_Handels_Off_Fcn(hObject, eventdata, handles)
set([handles.text5,handles.pushbutton8,handles.pushbutton9,handles.pushbutton10,handles.pushbutton11,handles.pushbutton12],'visible','off')


function Removing_Zoom_Information_Fcn(hObject, eventdata, handles)

evalin('base','clear xmin');evalin('base','clear ymin');

evalin('base','clear xmax');evalin('base','clear ymax');


function Assigning_Zoom_Information_Fcn(hObject, eventdata, handles)

global xmin ymin xmax ymax

assignin('base','xmin',xmin)

assignin('base','ymin',ymin)

assignin('base','xmax',xmax)

assignin('base','ymax',ymax)


function Set_2nd_Measurement_Keys_Off_Fcn(hObject, eventdata, handles)

set([handles.pushbutton61,handles.pushbutton62,handles.pushbutton63,handles.pushbutton64,handles.pushbutton65,...
    handles.pushbutton66,handles.pushbutton67,handles.pushbutton68,handles.pushbutton69],'visible','off')


function Naming_Vertebrae_Fcn(hObject, eventdata, handles)

global xt12 yt12 xl1 yl1 xl2 yl2 xl3 yl3 xl4 yl4 xl5 yl5 xs1 ys1 s1 l5 l4 l3 l2 l1 t12

t12=text(xt12,yt12,'T12','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle');

l1=text(xl1,yl1,'L1','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle');

l2=text(xl2,yl2,'L2','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle');

l3=text(xl3,yl3,'L3','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle');

l4=text(xl4,yl4,'L4','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle');

l5=text(xl5,yl5,'L5','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle');

s1=text(xs1,ys1,'S1','Color','y','FontSize',14,'HorizontalAlignment','Center','VerticalAlignment','Middle'); 


function Zoom_FcnI(hObject, eventdata, handles)

global disc SubjectID

xulz=load([pwd,'\Archive\',SubjectID,'\xuln ',num2str(disc)]);

yulz=load([pwd,'\Archive\',SubjectID,'\yuln ',num2str(disc)]);

xdlz=load([pwd,'\Archive\',SubjectID,'\xdln ',num2str(disc)]);

ydlz=load([pwd,'\Archive\',SubjectID,'\ydln ',num2str(disc)]);

if le(disc,3)
    
    xmin=round(xulz.xuln(1)-20);
    
    ymin=round(yulz.yuln(1)-20);
    
    xmax=round(xdlz.xdln(numel(xdlz.xdln))+20); 
    
    ymax=round(ydlz.ydln(numel(ydlz.ydln))+20);
    
else
    
    xmin=round(xulz.xuln(1)-20);
    
    ymin=round(yulz.yuln(numel(yulz.yuln))-20);
    
    xmax=round(xdlz.xdln(numel(xdlz.xdln))+20); 
    
    ymax=round(ydlz.ydln(1)+20);
end

set(gca,'XLim',[xmin,xmax],'YLim',[ymin,ymax]);

assignin('base','xmin',xmin)

assignin('base','ymin',ymin)

assignin('base','xmax',xmax)

assignin('base','ymax',ymax)


function Zoom_FcnII(hObject, eventdata, handles)

global disc xt12 yt12 xl1 yl1 xl2 yl2 xl3 yl3 xl4 yl4 xl5 yl5 xs1 ys1

clc

clear xulv yulv

if disc==1
    
    xmin=round(xt12-80);
    
    ymin=round(yt12);
    
    xmax=round(xl2+80);
    
    ymax=round(yl2); 
    
elseif disc==2
    
    xmin=round(xl1-80);
    
    ymin=round(yl1);
    
    xmax=round(xl3+80);
    
    ymax=round(yl3);  
    
elseif disc==3
    
    xmin=round(xl2-80);
    
    ymin=round(yl2);
    
    xmax=round(xl4+80);
    
    ymax=round(yl4);  
    
elseif disc==4
    
    xmin=round(xl3-80);
    
    ymin=round(yl3);
    
    xmax=round(xl5+80);
    
    ymax=round(yl5);   
    
elseif disc==5
    
    xmin=round(xl4-80);
    
    ymin=round(yl4);
    
    xmax=round(xs1+80);
    
    ymax=round(ys1);  
    
end

set(gca,'XLim',[xmin,xmax],'YLim',[ymin,ymax]);

assignin('base','xmin',xmin)

assignin('base','ymin',ymin)

assignin('base','xmax',xmax)

assignin('base','ymax',ymax)


function Turn_the_Keys_Off_Fcn(hObject, eventdata, handles)

set([handles.pushbutton14,handles.pushbutton15,handles.pushbutton17,handles.pushbutton30,handles.pushbutton33,...
    handles.pushbutton34,handles.pushbutton35,handles.pushbutton36,handles.pushbutton37,handles.pushbutton38,...
    handles.pushbutton45,handles.pushbutton61,handles.pushbutton62,handles.pushbutton63,handles.pushbutton64,...
    handles.pushbutton65,handles.pushbutton66,handles.pushbutton67,handles.pushbutton68,handles.pushbutton69],'visible','off')


function Moving_to_Desired_Level_Fcn(hObject, eventdata, handles)

global disc

set([handles.edit2,handles.text7],'visible','on')

Recalling_Old_Segmentation_Fcn(hObject, eventdata, handles)

set([handles.pushbutton14,handles.pushbutton15],'visible','on');

if disc==1
    
    eNROI=evalin('base','exist(''NROI1'')');
    
elseif disc==2
    
    eNROI=evalin('base','exist(''NROI2'')');
    
elseif disc==3
    
    eNROI=evalin('base','exist(''NROI3'')');
    
elseif disc==4
    
    eNROI=evalin('base','exist(''NROI4'')');
    
    
elseif disc==5
    
    eNROI=evalin('base','exist(''NROI5'')');
end

if eNROI==1
    set([handles.pushbutton68,handles.pushbutton69],'visible','on');
    
    if disc==1
        
        eAAROI=evalin('base','exist(''AAROI1'')');
    
    elseif disc==2
        
        eAAROI=evalin('base','exist(''AAROI2'')');
    
    elseif disc==3
        
        eAAROI=evalin('base','exist(''AAROI3'')');
    
    elseif disc==4
        
        eAAROI=evalin('base','exist(''AAROI4'')');
    
    elseif disc==5
        
        eAAROI=evalin('base','exist(''AAROI5'')');
    
    end
    
    if eAAROI==1
        
        set(handles.pushbutton65,'visible','on')
        
    else
        
        set(handles.pushbutton33,'visible','on','Enable','on');
    end
    
    if disc==1
        
        ePAROI=evalin('base','exist(''PAROI1'')');
    
    elseif disc==2
        
        ePAROI=evalin('base','exist(''PAROI2'')');
    
    elseif disc==3
        
        ePAROI=evalin('base','exist(''PAROI3'')');
    
    elseif disc==4
        
        ePAROI=evalin('base','exist(''PAROI4'')');
    
    elseif disc==5
        
        ePAROI=evalin('base','exist(''PAROI5'')');
    
    end
    
    if ePAROI==1
        
        set(handles.pushbutton64,'visible','on')
    
    else
        
        set(handles.pushbutton34,'visible','on','Enable','on')
    
    end
    
    if disc==1
        
        eSFTROI=evalin('base','exist(''SFTROI1'')');
    
    elseif disc==2
        
        eSFTROI=evalin('base','exist(''SFTROI2'')');
    
    elseif disc==3
        
        eSFTROI=evalin('base','exist(''SFTROI3'')');
    
    elseif disc==4
        
        eSFTROI=evalin('base','exist(''SFTROI4'')');
    
    elseif disc==5
        
        eSFTROI=evalin('base','exist(''SFTROI5'')');
    
    end
    
    if eSFTROI==1
        
        set(handles.pushbutton63,'visible','on')
    
    else
        
        set(handles.pushbutton35,'visible','on','Enable','on')
    
    end
    
    if disc==1
        
        eIFTROI=evalin('base','exist(''IFTROI1'')');
    
    elseif disc==2
        
        eIFTROI=evalin('base','exist(''IFTROI2'')');
    
    elseif disc==3
        
        eIFTROI=evalin('base','exist(''IFTROI3'')');
    
    elseif disc==4
        
        eIFTROI=evalin('base','exist(''IFTROI4'')');
    
    elseif disc==5
        
        eIFTROI=evalin('base','exist(''IFTROI5'')');
    
    end
    
    if eIFTROI==1
        
        set(handles.pushbutton62,'visible','on')
    
    else
        
        set(handles.pushbutton36,'visible','on','Enable','on')
    
    end
    
    if disc==1
        
        eSEROI=evalin('base','exist(''SEROI1'')');
    
    elseif disc==2
        
        eSEROI=evalin('base','exist(''SEROI2'')');
    
    elseif disc==3
        
        eSEROI=evalin('base','exist(''SEROI3'')');
    
    elseif disc==4
        
        eSEROI=evalin('base','exist(''SEROI4'')');
    
    elseif disc==5
        
        eSEROI=evalin('base','exist(''SEROI5'')');
    
    end
    
    if eSEROI==1
        
        set(handles.pushbutton66,'visible','on')
    
    else;set(handles.pushbutton37,'visible','on','Enable','on')
    
    end
    
    if disc==1
        
        eIEROI=evalin('base','exist(''IEROI1'')');
    
    elseif disc==2
        
        eIEROI=evalin('base','exist(''IEROI2'')');
    
    elseif disc==3
        
        eIEROI=evalin('base','exist(''IEROI3'')');
    
    elseif disc==4
        
        eIEROI=evalin('base','exist(''IEROI4'')');
    
    elseif disc==5
        
        eIEROI=evalin('base','exist(''IEROI5'')');
    
    end
    
    if eIEROI==1
        
        set(handles.pushbutton67,'visible','on')
    
    else
        
        set(handles.pushbutton38,'visible','on','Enable','on')
    
    end
    
    if disc==1
        
        eVROI=evalin('base','exist(''VROI1'')');
    
    elseif disc==2
        
        eVROI=evalin('base','exist(''VROI2'')');
    
    elseif disc==3
        
        eVROI=evalin('base','exist(''VROI3'')');
    
    elseif disc==4
        
        eVROI=evalin('base','exist(''VROI4'')');
    
    elseif disc==5
        
        eVROI=evalin('base','exist(''VROI5'')');
    
    end
    
    if eVROI==1
        
        set(handles.pushbutton61,'visible','on')
    
    else
        
        set(handles.pushbutton45,'visible','on','Enable','on')
    
    end
    
else
    
    waitfor(warndlg({'You should first segment the disc!'},'Spine GUI'));
    
    Upper_Line_Drawer_Function(hObject, eventdata, handles)
    
end

set([handles.uipanel1,handles.text6,handles.edit1,handles.pushbutton5,handles.pushbutton6],'visible','on')


function String_Cleaner_Fcn(hObject, eventdata, handles)

set([handles.edit3,handles.edit4,handles.edit5,handles.edit6,handles.edit7,handles.edit8,handles.edit9,...
    handles.edit10,handles.edit11,handles.edit12,handles.edit13],'String','')


function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit7_Callback(hObject, eventdata, handles)

function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit8_Callback(hObject, eventdata, handles)

function edit8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit9_Callback(hObject, eventdata, handles)

function edit9_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit10_Callback(hObject, eventdata, handles)

function edit10_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit11_Callback(hObject, eventdata, handles)

function edit11_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit12_Callback(hObject, eventdata, handles)

function edit12_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


function edit13_Callback(hObject, eventdata, handles)

function edit13_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end
