function fig_h=vis_pose_37(marker_xyz, varargin)
% marker xyz: marker xyz data in cell arrays
% frame_id (optional)

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
frame_start=1; frame_end=n_frames;

% if frame_id is specified
fig_h=figure();
if nargin == 2
    frame_start=varargin{1};
    frame_end=frame_start;
end

% marker color
marker_color=rand(n_markers,1);

% visualize
for i = frame_start : frame_end
    
     % set viewing angle
    for ii = 1 : n_markers % plot marker
        xyz_temp=[marker_xyz{ii}(i,1), marker_xyz{ii}(i, 2), marker_xyz{ii}(i, 3)];
        scatter3(xyz_temp(1), xyz_temp(2), xyz_temp(3),50, marker_color(ii),'filled');
        hold on
    end
    for jj = 1 : n_lines
        line_start=[marker_xyz{link_pair(jj,1)}(i,1),...
            marker_xyz{link_pair(jj,1)}(i,2),...
            marker_xyz{link_pair(jj,1)}(i,3)]; % line starts
        line_end=[marker_xyz{link_pair(jj,2)}(i,1),...
            marker_xyz{link_pair(jj,2)}(i,2),...
            marker_xyz{link_pair(jj,2)}(i,3)]; % lines ends
        line([line_start(1), line_end(1)], [line_start(2), line_end(2)],...
            [line_start(3), line_end(3)], 'Color','black'); % plot
       hold on;
    end
    title(['Frame #',num2str(i)]); % add title
    view([0 0 90]); % set viewing angle
%   drawnow;
    pause(0.00001);
    
     if i<frame_end % clear current figure if ...
        clf('reset');
     end
end

