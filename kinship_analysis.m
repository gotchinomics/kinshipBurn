clc
clear all
close all

load channeling_events

% Loading data from the dynamic table into regular vectors
gotchis = channelingevents.Gotchi_id;
parcels = channelingevents.Realm_id;
FUD = channelingevents.FUD;
FOMO = channelingevents.FOMO;
ALPHA = channelingevents.ALPHA;
KEK = channelingevents.KEK;
spillover = channelingevents.spilloverRate/10000;

% Getting day of each channeling event
blockDateTime = char(channelingevents.evt_block_time);
blockDate = string(blockDateTime(:,1:10));

% Calculating kinship based on the amount of FUD produced per channeling
kinship = 50*(FUD/(20)).^2;

% RF Leaderboard Cut-off Kinship @ 09/02/2023
kinshipCutoff(100)  = 1452;
kinshipCutoff(500)  = 1401;
kinshipCutoff(1000) = 1341;
kinshipCutoff(2000) = 1184;
kinshipCutoff(3000) = 1101;
kinshipCutoff(4000) = 1070;
kinshipCutoff(5000) = 1038;

% Evaluating data, calculating events per day contained in the snapshot
figure('Color','white')
histogram(datetime(blockDate))
ylabel('# channelings analysed')
grid on

%% Analysing data of a single day

% User input
selectedDay = '2023-02-05';

% Selecting active indices and calculating histogram
selectedRange = (blockDate == selectedDay);
selectedKinship = kinship(selectedRange);
[nGotchis, xAxis] = hist(selectedKinship,0:25:1700);

% Plotting results
figure('Position',[680   558   988   420]),
bar(xAxis, nGotchis)
hold on
xline(kinshipCutoff(100),'g','TOP100')
xline(kinshipCutoff(500),'m','TOP500')
xline(kinshipCutoff(2000),'b','TOP2K')
xline(kinshipCutoff(5000),'c','TOP5K')
xlabel('Kinship')
ylabel('#gotchis')
ylim([0 1000])
grid on

figure('Position',[681    48   985   420])
plot(xAxis,cumsum(nGotchis,'reverse'))
hold on
xline(kinshipCutoff(100),'g','TOP100')
xline(kinshipCutoff(500),'m','TOP500')
xline(kinshipCutoff(2000),'b','TOP2K')
xline(kinshipCutoff(5000),'c','TOP5K')
xlabel('Kinship')
ylabel('cumulative #gotchis')

