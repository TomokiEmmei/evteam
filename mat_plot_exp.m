close all;
clear all;      % これはclear allしないと動かないよ

%saveするか否か
 save_flag=1;

% データファイルのロード
filename='180423test1';
dirname='180423data';
dir_file_name=sprintf('raw/%s/%s', dirname, filename);
load(dir_file_name);
who_array=who; % work space内の変数リストを配列に格納
struct_name = char(who_array(5));        % clear allしていればワークスペース変数は構造体だけ

% 時間データの取得
time = eval([struct_name,'.X(1).Data']);

% 変数の個数を取得
n = size(eval([struct_name,'.Y']),2);

% 変数の取得
for k=1:n
    % 変数名を取得
    name = eval([struct_name,'.Y(k).Name']);    % 変数名文字列の取得
    dq_p = strfind(name,'"');                   % "の位置を取得
    name = name(dq_p(end-1)+1:dq_p(end)-1);     % 最後の"xxxx"の部分のみ抽出

    % 変数名にできない文字をアンダーバーに置換
    name = strrep(name,' ','_');
    name = strrep(name,'!','_');
    name = strrep(name,'#','_');
    name = strrep(name,'$','_');
    name = strrep(name,'%','_');
    name = strrep(name,'&','_');
    name = strrep(name,'''','_');
    name = strrep(name,'(','_');
    name = strrep(name,')','_');
    name = strrep(name,'~','_');
    name = strrep(name,'|','_');
    name = strrep(name,'@','_');
    name = strrep(name,'{','_');
    name = strrep(name,'}','_');
    name = strrep(name,'<','_');
    name = strrep(name,'>','_');
    name = strrep(name,'?','_');
    name = strrep(name,'\','_');
    name = strrep(name,'+','_');
    name = strrep(name,'-','_');    
    name = strrep(name,'*','_');
    name = strrep(name,'/','_');
    name = genvarname(name);        % 最終手段
    
    % 変数を取得
    eval([name,'=',struct_name,'.Y(k).Data;'])
end

% 読み込み過程で使った変数を削除
clear dq_p m n k name who_array dir_file_name;

% パラメータを復元させる場合下のスクリプトを有効にする
%fpev2_kanon_param_nc;

%保存
if save_flag==1
    savedir=sprintf('expand/%s', dirname);
    if  exist('expand') ~=7
        mkdir expand
    end
    if  exist(savedir) ~=7
        mkdir(savedir)
    end
savename=sprintf('expand/%s/%s_expand', dirname, filename);
save(savename);
clear savename dirname filename;
end

%% データの保存とプロット
%Yawのプロット
xmin = 0;
xmax = 10;

hfig = figure;%('Position',[50 50 450 350]);
plot(time, gamma_LPF+2.18, 'r', 'linewidth',3); hold on;
xlabel('Time [s]');
ylabel('Yaw rate [rad/s]');
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
xlim([xmin, xmax]);

if save_flag==1
savename = sprintf('fig/%s_gamma',struct_name);
expfig(savename,'-pdf','-emf','-png','-fig');
end

%前輪車輪角速度のプロット
hfig = figure;
xlabel('Time [sec]');
ylabel('Angular velocity [rad/s]');
plot(time, w_front_left, 'r', 'linewidth',3); hold on;
plot(time, w_front_right, 'b --', 'linewidth',3);
legend('FL','FR',1);
%title('Vehicle speed');
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
xlim([xmin, xmax]);

if save_flag==1
savename = sprintf('fig/%s_w_f',struct_name);
expfig(savename,'-pdf','-emf','-png','-fig');
end

%後輪車輪角速度のプロット
hfig = figure;
xlabel('Time [sec]');
ylabel('Angular velocity [rad/s]');
plot(time, w_rear_left, 'k', 'linewidth',3); hold on;
plot(time, w_rear_right, 'g --', 'linewidth',3);
legend('RL','RR',1);
%title('Vehicle speed');
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
xlim([xmin, xmax]);

if save_flag==1
savename = sprintf('fig/%s_w_r',struct_name);
expfig(savename,'-pdf','-emf','-png','-fig');
end

%入力トルクのプロット
% ymin = -400;
% ymax = 400;
hfig = figure;
plot(time, trq_real_front_left, 'r', 'linewidth',3); hold on;
plot(time, trq_real_front_right, 'b.-', 'linewidth',3);
plot(time, trq_real_rear_left, 'k--', 'linewidth',3);
plot(time, trq_real_rear_right, 'g--', 'linewidth',3);
legend('FL', 'FR', 'RL', 'RR', 1, 'Location','northeast');
xlabel('Time [sec]');
ylabel('Torque [Nm]');
pfig = pubfig(hfig);
pfig.LegendLoc = 'best';
xlim([xmin, xmax]);
% ylim([ymin, ymax]);
if save_flag==1
savename = sprintf('fig/%s_torque',struct_name);
expfig(savename,'-pdf','-emf','-png');
end

