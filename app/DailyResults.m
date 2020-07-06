classdef DailyResults
    properties (Access = public)
        t
        y
        
        Susceptibles
        Exposed
        Infected
        Recovered
        Med
        Dead
        Held
    end
    methods
        function obj = DailyResults(t, y)
            obj.t = t;
            obj.y = y;
            
            % extract populations
            numOfStates = 13;
             n = 0; % classes 1 - 2
            susAT_hr = y(:,numOfStates*n+1) + y(:,numOfStates*(n+1)+1) ;
            expAT_hr = y(:,numOfStates*n+2) + y(:,numOfStates*(n+1)+2) ;
            infAT_hr = y(:,numOfStates*n+3) + y(:,numOfStates*(n+1)+3) ;
            recAT_hr = y(:,numOfStates*n+4) + y(:,numOfStates*(n+1)+4) ;
            medAT_hr = y(:,numOfStates*n+5) + y(:,numOfStates*(n+1)+5);
            deadAT_hr = y(:,numOfStates*n+6) + y(:,numOfStates*(n+1)+6) ;
            held_sAT_hr = y(:,numOfStates*n+7) + y(:,numOfStates*(n+1)+7) ;
            held_eAT_hr = y(:,numOfStates*n+8) + y(:,numOfStates*(n+1)+8) ;
            heldAT_hr = held_sAT_hr + held_eAT_hr;
            
            
            % Admin/Teaching - Low Risk
            n = 0; % classes 3 - 4
            susAT_lr = y(:,numOfStates*(n+2)+1) + y(:,numOfStates*(n+3)+1);
            expAT_lr =  y(:,numOfStates*(n+2)+2) + y(:,numOfStates*(n+3)+2);
            infAT_lr = y(:,numOfStates*(n+2)+3) + y(:,numOfStates*(n+3)+3);
            recAT_lr =  y(:,numOfStates*(n+2)+4) + y(:,numOfStates*(n+3)+4);
            medAT_lr =  y(:,numOfStates*(n+2)+5) + y(:,numOfStates*(n+3)+5);
            deadAT_lr =  y(:,numOfStates*(n+2)+6) + y(:,numOfStates*(n+3)+6);
            held_sAT_lr = y(:,numOfStates*(n+2)+7) + y(:,numOfStates*(n+3)+7);
            held_eAT_lr =  y(:,numOfStates*(n+2)+8) + y(:,numOfStates*(n+3)+8);
            heldAT_lr = held_sAT_lr + held_eAT_lr;
            
            
            % Staff_hr
            n = 4; % classes 5 - 6
            susStaff_hr = y(:,numOfStates*n+1) + y(:,numOfStates*(n+1)+1);
            expStaff_hr = y(:,numOfStates*n+2) + y(:,numOfStates*(n+1)+2) ;
            infStaff_hr = y(:,numOfStates*n+3) + y(:,numOfStates*(n+1)+3) ;
            recStaff_hr = y(:,numOfStates*n+4) + y(:,numOfStates*(n+1)+4) ;
            medStaff_hr = y(:,numOfStates*n+5) + y(:,numOfStates*(n+1)+5) ;
            deadStaff_hr = y(:,numOfStates*n+6) + y(:,numOfStates*(n+1)+6) ;
            held_sStaff_hr = y(:,numOfStates*n+7) + y(:,numOfStates*(n+1)+7) ;
            held_eStaff_hr = y(:,numOfStates*n+8) + y(:,numOfStates*(n+1)+8) ;
            heldStaff_hr = held_sStaff_hr + held_eStaff_hr;
            
            % Staff_lr
            n = 4; % classes 7 - 8
            susStaff_lr =  y(:,numOfStates*(n+2)+1) + y(:,numOfStates*(n+3)+1);
            expStaff_lr =  y(:,numOfStates*(n+2)+2) + y(:,numOfStates*(n+3)+2);
            infStaff_lr =  y(:,numOfStates*(n+2)+3) + y(:,numOfStates*(n+3)+3);
            recStaff_lr =  y(:,numOfStates*(n+2)+4) + y(:,numOfStates*(n+3)+4);
            medStaff_lr = y(:,numOfStates*(n+2)+5) + y(:,numOfStates*(n+3)+5);
            deadStaff_lr = y(:,numOfStates*(n+2)+6) + y(:,numOfStates*(n+3)+6);
            held_sStaff_lr =  y(:,numOfStates*(n+2)+7) + y(:,numOfStates*(n+3)+7);
            held_eStaff_lr = y(:,numOfStates*(n+2)+8) + y(:,numOfStates*(n+3)+8);
            heldStaff_lr = held_sStaff_lr + held_eStaff_lr;
            
            
            % Compliant Students
            n = 8; % class 9
            susStud_c = y(:,numOfStates*n+1) ;
            expStud_c = y(:,numOfStates*n+2) ;
            infStud_c = y(:,numOfStates*n+3) ;
            recStud_c = y(:,numOfStates*n+4) ;
            medStud_c = y(:,numOfStates*n+5) ;
            deadStud_c = y(:,numOfStates*n+6) ;
            held_sStud_c = y(:,numOfStates*n+7);
            held_eStud_c = y(:,numOfStates*n+8);
            heldStud_c = held_sStud_c + held_eStud_c;
            
            % Non-compliant Students
            % Compliant Students
            n = 9; % class 10
            susStud_nc = y(:,numOfStates*n+1) ;
            expStud_nc = y(:,numOfStates*n+2) ;
            infStud_nc = y(:,numOfStates*n+3) ;
            recStud_nc = y(:,numOfStates*n+4) ;
            medStud_nc = y(:,numOfStates*n+5) ;
            deadStud_nc = y(:,numOfStates*n+6) ;
            held_sStud_nc = y(:,numOfStates*n+7);
            held_eStud_nc = y(:,numOfStates*n+8);
            held_iStud_nc = y(:,numOfStates*n+9);
            heldStud_nc = held_sStud_nc + held_eStud_nc + held_iStud_nc;
            
            %% Put columns from each class into a matrix
            obj.Susceptibles = [susAT_hr, susAT_lr, susStaff_hr, susStaff_lr, susStud_c, susStud_nc];
            obj.Exposed = [expAT_hr, expAT_lr, expStaff_hr, expStaff_lr, expStud_c, expStud_nc];
            obj.Infected = [infAT_hr, infAT_lr, infStaff_hr, infStaff_lr, infStud_c, infStud_nc];
            obj.Recovered = [recAT_hr, recAT_lr, recStaff_hr, recStaff_lr, recStud_c, recStud_nc];
            obj.Med = [medAT_hr, medAT_lr, medStaff_hr, medStaff_lr, medStud_c, medStud_nc];
            obj.Dead = [deadAT_hr, deadAT_lr, deadStaff_hr, deadStaff_lr, deadStud_c, deadStud_nc];
            obj.Held = [heldAT_hr, heldAT_lr, heldStaff_hr, heldStaff_lr, heldStud_c, heldStud_nc];
            
            
            %% either:
            %obj.Susceptibles_C = %... [susAT_hr, susAT_lr, susStaff_hr, susStaff_lr, susStud_c, susStud_nc];
            %obj.Exposed_C = %..  [expAT_hr, expAT_lr, expStaff_hr, expStaff_lr, expStud_c, expStud_nc];
            %obj.Infected_C = %..[infAT_hr, infAT_lr, infStaff_hr, infStaff_lr, infStud_c, infStud_nc];
            %obj.Recovered_C = %..[recAT_hr, recAT_lr, recStaff_hr, recStaff_lr, recStud_c, recStud_nc];
            %obj.Med_C = %..[medAT_hr, medAT_lr, medStaff_hr, medStaff_lr, medStud_c, medStud_nc];
            %obj.Dead_C = %..[deadAT_hr, deadAT_lr, deadStaff_hr, deadStaff_lr, deadStud_c, deadStud_nc];
            %obj.Held_C = %..[heldAT_hr, heldAT_lr, heldStaff_hr, heldStaff_lr, heldStud_c, heldStud_nc];
        end
        
         function z = selectDailyPops(obj, selection)
            
            % Possible selections: vector of 1's and 0's representing inclusion of
            % TA_hr, TA_lr, Staff_hr, Staff_lr, Stu_compliant, Stu_noncompliant
            n_select = length(selection);
            % Make "selection" a column vector
            s = reshape(selection, n_select,1);
            z = PlotData(obj.Susceptibles * s, ...
                obj.Exposed *s, ...
                obj.Infected *s, ...
                obj.Recovered *s, ...
                obj.Med *s, ...
                obj.Dead *s, ...
                obj.Held *s);
        end % selectPops
        
                
         function z = selectPops(obj, selection)
            
            % Possible selections: vector of 1's and 0's representing inclusion of
            % TA_hr, TA_lr, Staff_hr, Staff_lr, Stu_compliant, Stu_noncompliant
            n_select = length(selection);
            % Make "selection" a column vector
            s = reshape(selection, n_select,1);
            z = PlotData(obj.Susceptibles * s, ...
                obj.Exposed *s, ...
                obj.Infected *s, ...
                obj.Recovered *s, ...
                obj.Med *s, ...
                obj.Dead *s, ...
                obj.Held *s);
        end % selectPops
    end
end
