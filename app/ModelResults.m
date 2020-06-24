classdef ModelResults
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
        function obj = ModelResults(t, y)
            obj.t = t;
            obj.y = y;
            
            % extract populations
             n = 0; % classes 1 - 2
            susAdminTeach_hr = y(:,8*n+1) + y(:,8*(n+1)+1) ;
            expAdminTeach_hr = y(:,8*n+2) + y(:,8*(n+1)+2) ;
            infAdminTeach_hr = y(:,8*n+3) + y(:,8*(n+1)+3) ;
            recAdminTeach_hr = y(:,8*n+4) + y(:,8*(n+1)+4) ;
            medAdminTeach_hr = y(:,8*n+5) + y(:,8*(n+1)+5);
            deadAdminTeach_hr = y(:,8*n+6) + y(:,8*(n+1)+6) ;
            held_sAdminTeach_hr = y(:,8*n+7) + y(:,8*(n+1)+7) ;
            held_eAdminTeach_hr = y(:,8*n+8) + y(:,8*(n+1)+8) ;
            heldAdminTeach_hr = held_sAdminTeach_hr + held_eAdminTeach_hr;
            
            % Admin/Teaching - Low Risk
            n = 0; % classes 3 - 4
            susAdminTeach_lr = y(:,8*(n+2)+1) + y(:,8*(n+3)+1);
            expAdminTeach_lr =  y(:,8*(n+2)+2) + y(:,8*(n+3)+2);
            infAdminTeach_lr = y(:,8*(n+2)+3) + y(:,8*(n+3)+3);
            recAdminTeach_lr =  y(:,8*(n+2)+4) + y(:,8*(n+3)+4);
            medAdminTeach_lr =  y(:,8*(n+2)+5) + y(:,8*(n+3)+5);
            deadAdminTeach_lr =  y(:,8*(n+2)+6) + y(:,8*(n+3)+6);
            held_sAdminTeach_lr = y(:,8*(n+2)+7) + y(:,8*(n+3)+7);
            held_eAdminTeach_lr =  y(:,8*(n+2)+8) + y(:,8*(n+3)+8);
            heldAdminTeach_lr = held_sAdminTeach_lr + held_eAdminTeach_lr;
            
            
            % Staff_hr
            n = 4; % classes 5 - 6
            susStaff_hr = y(:,8*n+1) + y(:,8*(n+1)+1);
            expStaff_hr = y(:,8*n+2) + y(:,8*(n+1)+2) ;
            infStaff_hr = y(:,8*n+3) + y(:,8*(n+1)+3) ;
            recStaff_hr = y(:,8*n+4) + y(:,8*(n+1)+4) ;
            medStaff_hr = y(:,8*n+5) + y(:,8*(n+1)+5) ;
            deadStaff_hr = y(:,8*n+6) + y(:,8*(n+1)+6) ;
            held_sStaff_hr = y(:,8*n+7) + y(:,8*(n+1)+7) ;
            held_eStaff_hr = y(:,8*n+8) + y(:,8*(n+1)+8) ;
            heldStaff_hr = held_sStaff_hr + held_eStaff_hr;
            
            % Staff_lr
            n = 4; % classes 7 - 8
            susStaff_lr =  y(:,8*(n+2)+1) + y(:,8*(n+3)+1);
            expStaff_lr =  y(:,8*(n+2)+2) + y(:,8*(n+3)+2);
            infStaff_lr =  y(:,8*(n+2)+3) + y(:,8*(n+3)+3);
            recStaff_lr =  y(:,8*(n+2)+4) + y(:,8*(n+3)+4);
            medStaff_lr = y(:,8*(n+2)+5) + y(:,8*(n+3)+5);
            deadStaff_lr = y(:,8*(n+2)+6) + y(:,8*(n+3)+6);
            held_sStaff_lr =  y(:,8*(n+2)+7) + y(:,8*(n+3)+7);
            held_eStaff_lr = y(:,8*(n+2)+8) + y(:,8*(n+3)+8);
            heldStaff_lr = held_sStaff_lr + held_eStaff_lr;
            
            
            % Compliant Students
            n = 8; % class 9
            susStud_c = y(:,8*n+1) ;
            expStud_c = y(:,8*n+2) ;
            infStud_c = y(:,8*n+3) ;
            recStud_c = y(:,8*n+4) ;
            medStud_c = y(:,8*n+5) ;
            deadStud_c = y(:,8*n+6) ;
            held_sStud_c = y(:,8*n+7);
            held_eStud_c = y(:,8*n+8);
            heldStud_c = held_sStud_c + held_eStud_c;
            
            % Non-compliant Students
            % Compliant Students
            n = 9; % class 10
            susStud_nc = y(:,8*n+1) ;
            expStud_nc = y(:,8*n+2) ;
            infStud_nc = y(:,8*n+3) ;
            recStud_nc = y(:,8*n+4) ;
            medStud_nc = y(:,8*n+5) ;
            deadStud_nc = y(:,8*n+6) ;
            held_sStud_nc = y(:,8*n+7);
            held_eStud_nc = y(:,8*n+8);
            held_iStud_nc = y(:,end);
            heldStud_nc = held_sStud_nc + held_eStud_nc + held_iStud_nc;
            
            %% Put columns from each class into a matrix
            obj.Susceptibles = [susAdminTeach_hr, susAdminTeach_lr, susStaff_hr, susStaff_lr, susStud_c, susStud_nc];
            obj.Exposed = [expAdminTeach_hr, expAdminTeach_lr, expStaff_hr, expStaff_lr, expStud_c, expStud_nc];
            obj.Infected = [infAdminTeach_hr, infAdminTeach_lr, infStaff_hr, infStaff_lr, infStud_c, infStud_nc];
            obj.Recovered = [recAdminTeach_hr, recAdminTeach_lr, recStaff_hr, recStaff_lr, recStud_c, recStud_nc];
            obj.Med = [medAdminTeach_hr, medAdminTeach_lr, medStaff_hr, medStaff_lr, medStud_c, medStud_nc];
            obj.Dead = [deadAdminTeach_hr, deadAdminTeach_lr, deadStaff_hr, deadStaff_lr, deadStud_c, deadStud_nc];
            obj.Held = [heldAdminTeach_hr, heldAdminTeach_lr, heldStaff_hr, heldStaff_lr, heldStud_c, heldStud_nc];
        end
        
         function z = selectPops(obj, selection)
            
            % Possible selections: vector of 1's and 0's representing inclusion of
            % TA_hr, TA_lr, Staff_hr, Staff_lr, Stu_compliant, Stu_noncompliant
            n_select = length(selection);
            % Make "selection" a column vector
            s = reshape(selection, n_select,1);
            z = PlotSelection(obj.Susceptibles * s, ...
                obj.Exposed *s, ...
                obj.Infected *s, ...
                obj.Recovered *s, ...
                obj.Med *s, ...
                obj.Dead *s, ...
                obj.Held *s);
        end % selectPops
    end
end
