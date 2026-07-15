% =====================================================
% Loan Approval Expert System
% Tool: SWI-Prolog
% =====================================================

:- dynamic answer/2.

% -------------------------------
% Start system
% -------------------------------

main :-
    write('======================================'), nl,
    write(' LOAN APPROVAL EXPERT SYSTEM'), nl,
    write('======================================'), nl,
    write('Please answer all questions carefully.'), nl,
    nl,
    collect_inputs,
    nl,
    make_decision,
    clear_answers.

% -------------------------------
% Collect user inputs
% -------------------------------

collect_inputs :-
    ask_number(income, 'Enter your annual income: '),
    ask_number(credit_score, 'Enter your credit score: '),
    ask_atom(employment_status, 'Enter employment status (employed/self_employed/unemployed): '),
    ask_number(loan_amount, 'Enter requested loan amount: '),
    ask_atom(collateral, 'Do you have collateral? (yes/no): '),
    ask_number(existing_debt, 'Enter existing debt amount: '),
    ask_number(years_employed, 'Enter number of years employed: ').

ask_number(Field, Question) :-
    write(Question),
    read(Value),
    assertz(answer(Field, Value)).

ask_atom(Field, Question) :-
    write(Question),
    read(Value),
    assertz(answer(Field, Value)).

% -------------------------------
% Loan decision
% -------------------------------

make_decision :-
    approved,
    !,
    write('Decision: APPROVED'), nl,
    write('Reason: Applicant satisfies the loan approval rules.'), nl,
    recommendation.

make_decision :-
    write('Decision: REJECTED'), nl,
    write('Reason: Applicant does not satisfy the loan approval rules.'), nl,
    rejection_reason.

% -------------------------------
% Main approval rule
% -------------------------------

approved :-
    acceptable_income,
    acceptable_credit_score,
    stable_employment,
    acceptable_debt,
    acceptable_loan_amount,
    security_available.

% -------------------------------
% Knowledge base rules
% At least 10 rules
% -------------------------------

% Rule 1: Income must be at least 30000
acceptable_income :-
    answer(income, Income),
    Income >= 30000.

% Rule 2: Credit score must be at least 600
acceptable_credit_score :-
    answer(credit_score, Score),
    Score >= 600.

% Rule 3: Applicant must not be unemployed
stable_employment :-
    answer(employment_status, Status),
    Status \= unemployed.

% Rule 4: Applicant should have worked for at least 1 year
stable_employment :-
    answer(years_employed, Years),
    Years >= 1.

% Rule 5: Existing debt must not be more than 50% of income
acceptable_debt :-
    answer(existing_debt, Debt),
    answer(income, Income),
    Debt =< Income * 0.5.

% Rule 6: Loan amount should not exceed 3 times annual income
acceptable_loan_amount :-
    answer(loan_amount, Loan),
    answer(income, Income),
    Loan =< Income * 3.

% Rule 7: Collateral improves approval chances
security_available :-
    answer(collateral, yes).

% Rule 8: If loan amount is small, collateral is not compulsory
security_available :-
    answer(loan_amount, Loan),
    Loan =< 10000.

% Rule 9: Excellent credit score can support approval
acceptable_credit_score :-
    answer(credit_score, Score),
    Score >= 750.

% Rule 10: Self-employed applicant must have at least 2 years of work history
stable_employment :-
    answer(employment_status, self_employed),
    answer(years_employed, Years),
    Years >= 2.

% Rule 11: Very high debt causes rejection
high_risk_debt :-
    answer(existing_debt, Debt),
    answer(income, Income),
    Debt > Income * 0.7.

% Rule 12: Very low credit score causes rejection
poor_credit :-
    answer(credit_score, Score),
    Score < 500.

% -------------------------------
% Recommendation
% -------------------------------

recommendation :-
    write('Recommendation: Loan can be granted, but final verification should be done by the financial institution.'), nl.

% -------------------------------
% Rejection reasons
% -------------------------------

rejection_reason :-
    poor_credit,
    write('Specific reason: Credit score is too low.'), nl, !.

rejection_reason :-
    high_risk_debt,
    write('Specific reason: Existing debt is too high compared to income.'), nl, !.

rejection_reason :-
    \+ acceptable_income,
    write('Specific reason: Annual income is below the required level.'), nl, !.

rejection_reason :-
    \+ stable_employment,
    write('Specific reason: Employment status or work history is not stable.'), nl, !.

rejection_reason :-
    \+ acceptable_loan_amount,
    write('Specific reason: Requested loan amount is too high compared to income.'), nl, !.

rejection_reason :-
    \+ security_available,
    write('Specific reason: Collateral is required for this loan amount.'), nl, !.

rejection_reason :-
    write('Specific reason: Applicant failed to meet one or more approval conditions.'), nl.

% -------------------------------
% Clear stored answers
% -------------------------------

clear_answers :-
    retract(answer(_, _)),
    fail.

clear_answers.