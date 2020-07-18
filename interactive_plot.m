%% Create empty main page
close all; clc;
mpage.fig = figure('position',[50, 50, 1200, 600],'color','w');
mpage.marker_axes=subplot(1,2,1);
mpage.image_axes=subplot(1,2,2);
mpage.marker_axes.Position=mpage.marker_axes.Position+[0,0, -0.1,0];
mpage.image_axes.Position=mpage.image_axes.Position+[-0.1,0, 0.1,0];
annotation('line',[0.4 0.4],[0 1], 'LineWidth',2);
annotation('textbox', [0.001, 0.0005, 0.1, 0.1], 'string', 'Marker',...
    'FitBoxToText','on', 'FontSize', 18, 'Color', 'g', ...
    'EdgeColor', 'None');
annotation('textbox', [0.93, 0.0005, 0.1, 0.1], 'string', 'Video',...
    'FitBoxToText','on', 'FontSize', 18, 'Color', 'r', ...
    'EdgeColor', 'None');
%% init
global pose_st;
global marker_fid;
global video_st;
global frame_id;
global video_current_time;
global marker_info_annot_handle;
global video_info_annot_handle;
%% Marker loading button
mpage.marker_bt1 = uicontrol('style','push',...
    'units','normalized',...
    'position',[5/1200 550/600 100/1200 30/600],...
    'fontsize',7,...
    'string','Choose Marker File',...
    'Backgroundcolor','g',...
    'FontWeight', 'bold',...
    'callback',{@marker_file_select, mpage});
%% Next/previous marker frame
mpage.marker_bt2 = uicontrol('style','push',...
    'units','normalized',...
    'position',[5/1200 500/600 80/1200 20/600],...
    'fontsize',7,...
    'string','Next ->',...
    'callback',{@go_to_next_marker_frame, mpage});
mpage.marker_bt3 = uicontrol('style','push',...
    'units','normalized',...
    'position',[5/1200 450/600 80/1200 20/600],...
    'fontsize',7,...
    'string','<- Previous',...
    'callback',{@go_to_previous_marker_frame, mpage});
%% reset pose view angle
mpage.marker_bt4 = uicontrol('style','push',...
    'units','normalized',...
    'position',[5/1200 400/600 90/1200 20/600],...
    'fontsize',7,...
    'string','Reset View Angle',...
    'callback',{@reset_view_angle, mpage});
%% go to marker frame
mpage.marker_bt5 = uicontrol('style','edit',...
    'units','normalized',...
    'position',[5/1200 350/600 80/1200 20/600],...
    'fontsize',7,...
    'string','Enter Frame ID');
mpage.marker_bt6 = uicontrol('style','push',...
    'units','normalized',...
    'position',[90/1200 350/600 30/1200 20/600],...
    'fontsize',7,...
    'string','Go',...
    'callback',{@go_to_entered_marker_frame, mpage});
mpage.marker_bt7 = uicontrol('style','text',...
    'units','normalized',...
    'position',[5/1200 330/600 80/1200 20/600],...
    'fontsize',7,...
    'string','*Frame ID*',...
    'BackgroundColor', 'w');

%% Video loading button
mpage.video_bt1 = uicontrol('style','push',...
    'units','normalized',...
    'position',[1080/1200 550/600 100/1200 30/600],...
    'fontsize',7,...
    'string','Choose Video File',...
    'Backgroundcolor','r',...
    'FontWeight', 'bold',...
    'callback',{@video_file_select, mpage});
%% Next/previous video frame
mpage.video_bt2 = uicontrol('style','push',...
    'units','normalized',...
    'position',[1100/1200 500/600 80/1200 20/600],...
    'fontsize',7,...
    'string','Next ->',...
    'callback',{@go_to_next_video_frame, mpage});
mpage.video_bt3 = uicontrol('style','push',...
    'units','normalized',...
    'position',[1100/1200 450/600 80/1200 20/600],...
    'fontsize',7,...
    'string','<- Previous',...
    'callback',{@go_to_previous_video_frame, mpage});
%% go to video frame
mpage.video_bt4 = uicontrol('style','edit',...
    'units','normalized',...
    'position',[1090/1200 400/600 70/1200 20/600],...
    'fontsize',7,...
    'string','Enter Frame ID');
mpage.video_bt5 = uicontrol('style','push',...
    'units','normalized',...
    'position',[1160/1200 400/600 30/1200 20/600],...
    'fontsize',7,...
    'string','Go',...
    'callback',{@go_to_entered_video_frame, mpage});
mpage.video_bt6 = uicontrol('style','text',...
    'units','normalized',...
    'position',[1090/1200 380/600 80/1200 20/600],...
    'fontsize',7,...
    'string','*Frame ID*',...
    'BackgroundColor', 'w');
%% Marker callback functions
function marker_file_select(~,~, mpage)
global marker_fid;
global pose_st;
global marker_info_annot_handle;
[file_name,file_path] = uigetfile('*.mat');
pose_st=load(fullfile(file_path, file_name));
if isempty(pose_st) % if file loaded
    warndlg("Load Failed !"); return
else
    % pick up IDs from file name
    sub_id=str2num(file_name(4:5));
    task_id=str2num(file_name(7:8));
    task_iid=str2num(file_name(10:11));
    % make sure id in range
    if ~(sub_id>=2)&&(sub_id<=12)&&(task_id>=1)&&(task_id<=25)&&...
            (task_iid>=1)&&(task_iid<=4)
        warndlg("Wrong File Loaded"); return;
    end
    mf_id_str=['Subject ID:', num2str(sub_id),...
        '  Task ID: ', num2str(task_id),...
        '  Trial:', num2str(task_iid)];
    % clear annot info handle 
    delete(marker_info_annot_handle);
    marker_info_annot_handle=annotation('textbox', [0.12, 0.025, 0.3, 0.040], 'string', mf_id_str,...
        'FitBoxToText','on', 'FontSize', 13);
    marker_fid=1; % set to 1 when load new marker file
    marker_st=pose_st.xyz_all{3};
    marker_xyz=marker_st(:,2);
    cla(mpage.marker_axes);
    vis_pose_37_gui(marker_xyz, marker_fid, mpage.marker_axes); % vis the 1st frame by default
end
end

function go_to_next_marker_frame(~,~, mpage)
global marker_fid;
global pose_st;
marker_fid=marker_fid+1;
marker_st=pose_st.xyz_all{3};
marker_xyz=marker_st(:,2);
if marker_fid>length(marker_xyz{2})
    warndlg("ID Out of Range !");
    marker_fid=marker_fid-1;return;
end
cla(mpage.marker_axes);% clear previous axes
vis_pose_37_gui(marker_xyz, marker_fid, mpage.marker_axes);
end

function go_to_previous_marker_frame(~,~, mpage)
global marker_fid;
global pose_st;
marker_fid=marker_fid-1;
marker_st=pose_st.xyz_all{3};
marker_xyz=marker_st(:,2);
if marker_fid<1
    warndlg("ID Out of Range !");
    marker_fid=marker_fid+1;return;
end
cla(mpage.marker_axes);% clear previous axes
vis_pose_37_gui(marker_xyz, marker_fid, mpage.marker_axes); % vis the 1st frame by default
end

function reset_view_angle(~,~, mpage)
view(mpage.marker_axes,[0 0 90]);
end

function go_to_entered_marker_frame(~,~, mpage)
global marker_fid;
global pose_st;

entered_id=int16(str2num(get(mpage.marker_bt5, 'String')));
if isempty(entered_id) % check input
    warndlg("Please enter integer !");return;
end
marker_st=pose_st.xyz_all{3};
marker_xyz=marker_st(:,2);
if entered_id>length(marker_xyz{2}) || entered_id<1 % check range
    warndlg("ID Out of Range !");return;
end
marker_fid=entered_id;
cla(mpage.marker_axes);% clear previous axes
vis_pose_37_gui(marker_xyz, marker_fid, mpage.marker_axes);
end


%% Video callback functions
function video_file_select(~,~, mpage)
global video_st;
global frame_id;
global video_info_annot_handle;
[file_name,file_path] = uigetfile('*.avi'); % load video
% pick up IDs from file name
sub_id=str2num(file_name(4:5));
task_id=str2num(file_name(7:8));
task_iid=str2num(file_name(10:11));
% make sure id in range
if ~(sub_id>=2)&&(sub_id<=12)&&(task_id>=1)&&(task_id<=25)&&...
        (task_iid>=1)&&(task_iid<=4)
    warndlg("Wrong File Loaded"); return;
end
% create video struct
video_file_path=fullfile(file_path, file_name);
frame_id=1;frame_cnt=1;video_st = VideoReader(video_file_path);
% get that frame
while hasFrame(video_st)&&frame_cnt<=frame_id
    frame = readFrame(video_st);
    frame_cnt=frame_cnt+1;
end
video_st.CurrentTime=0; % reset current time
imshow(frame, 'Parent', mpage.image_axes); % display image
mf_id_str=['Subject ID:', num2str(sub_id),...% add text box for id
    '  Task ID: ', num2str(task_id),...
    '  Trial:', num2str(task_iid)];
delete(video_info_annot_handle);
video_info_annot_handle=annotation('textbox', [0.58, 0.1, 0.3, 0.040], 'string', mf_id_str,...
    'FitBoxToText','on', 'FontSize', 13);
title(['Video Frame #',num2str(frame_id)],'Parent', mpage.image_axes); % add title
end

function go_to_next_video_frame(~,~, mpage)
global video_st;
global frame_id;
frame_id=frame_id+1;% next frame
% make sure frame id in range
if frame_id >video_st.FrameRate*video_st.Duration
    warndlg("ID Out of Range !");
    frame_id=frame_id-1;return;
end
% get that frame
frame_cnt=1;
while hasFrame(video_st)&&frame_cnt<=frame_id
    frame = readFrame(video_st);
    frame_cnt=frame_cnt+1;
end
video_st.CurrentTime=0; % reset current time
imshow(frame, 'Parent', mpage.image_axes); % display image
title(['Video Frame #',num2str(frame_id)],'Parent', mpage.image_axes); % add title
end

function go_to_previous_video_frame(~,~, mpage)
global video_st;
global frame_id;
frame_id=frame_id-1;% next frame
% make sure frame id in range
if frame_id <1
    warndlg("ID Out of Range !");
    frame_id=frame_id+1;return;
end
% get that frame
frame_cnt=1;
while hasFrame(video_st)&&frame_cnt<=frame_id
    frame = readFrame(video_st);
    frame_cnt=frame_cnt+1;
end
video_st.CurrentTime=0; % reset current time
imshow(frame, 'Parent', mpage.image_axes); % display image
title(['Video Frame #',num2str(frame_id)],'Parent', mpage.image_axes); % add title
end

function go_to_entered_video_frame(~,~, mpage)
global video_st;
global frame_id;
entered_id=int16(str2num(get(mpage.video_bt4, 'String')));
if isempty(entered_id) % check input
    warndlg("Please enter integer !");return;
end
% make sure frame id in range
if entered_id >video_st.FrameRate*video_st.Duration||entered_id<1
    warndlg("ID Out of Range !");return;
end
frame_id=entered_id;
% get that frame
frame_cnt=1;
while hasFrame(video_st)&&frame_cnt<=frame_id
    frame = readFrame(video_st);
    frame_cnt=frame_cnt+1;
end
video_st.CurrentTime=0; % reset current time
imshow(frame, 'Parent', mpage.image_axes); % display image
title(['Video Frame #',num2str(frame_id)],'Parent', mpage.image_axes); % add title
end
%% other functions
function vis_pose_37_gui(marker_xyz, frame_id, axes_handle)
% marker xyz: marker xyz data in cell arrays
% frame_id
% axes

% linked marker pair
link_pair=[1 2; 1 3; 2 3; 1 6; 4 6; 5 6; 4 7; 5 7;...
    6 7; 6 8; 7 8; 6 9; 7 9; 8 9; 4 10; 5 11;...
    12 4; 10 12; 5 13; 13 11;10 14;12 14;11 15;13 15;...
    10 16; 16 12; 14 16; 17 11; 17 13; 17 15; 18 9; 19 9;...
    19 18; 20 8; 20 18; 20 19; 21 8; 21 18; 19 21; 21 20;...
    18 22; 19 23; 18 24; 22 24; 19 25; 23 25; 26 18; 22 26;...
    24 26; 27 19; 27 23; 25 27; 22 28; 26 28; 23 29; 27 29;...
    22 30; 24 30; 28 30; 23 31; 25 31; 29 31; 28 32; 32 30;...
    29 33; 31 33; 34 28; 34 30; 32 34; 29 35; 31 35; 33 35];

n_frames=length(marker_xyz{1}); % number of frames
n_markers=length(marker_xyz); % number of markers
n_lines=length(link_pair); % number of lines

% marker color
marker_color=rand(n_markers,1);

% visualize
for ii = 1 : n_markers % plot marker
    xyz_temp=[marker_xyz{ii}(frame_id,1), marker_xyz{ii}(frame_id, 2), marker_xyz{ii}(frame_id, 3)];
    scatter3(xyz_temp(1), xyz_temp(2), xyz_temp(3),50, marker_color(ii),'filled',...
        'Parent', axes_handle);
    set(axes_handle,'nextplot','add')
end
for jj = 1 : n_lines
    line_start=[marker_xyz{link_pair(jj,1)}(frame_id,1),...
        marker_xyz{link_pair(jj,1)}(frame_id,2),...
        marker_xyz{link_pair(jj,1)}(frame_id,3)]; % line starts
    line_end=[marker_xyz{link_pair(jj,2)}(frame_id,1),...
        marker_xyz{link_pair(jj,2)}(frame_id,2),...
        marker_xyz{link_pair(jj,2)}(frame_id,3)]; % lines ends
    line([line_start(1), line_end(1)], [line_start(2), line_end(2)],...
        [line_start(3), line_end(3)], 'Color','black', 'Parent', axes_handle); % plot
    set(axes_handle,'nextplot','add');
end
title(['Marker Frame #',num2str(frame_id)],'Parent', axes_handle); % add title
if frame_id==1
    view(axes_handle,[0 0 90]); % set viewing angle
end
% drawnow;
% pause(0.00001);

% if frame_id<frame_end % clear current figure if ...
%     clf('reset');
% end
end

