# Kakao-From-Games-to-Chats
### *A Panel DID study on how gaming app adoption influences social media usage.*

**Kakao** is a South Korean technology company that provides a wide range of digital services and mobile applications. It is best known for its messaging app **KakaoTalk** and networking app **KakaoStory**. In 2012, Kakao platform released its first-ever gaming app **"Anipang"** and it quickly became a hit. 

This project is interested in **how the adoption of a popular gaming app will affect users’ app usage behavior**.

```mermaid
graph TD
A[Anipang Adoption (Control/Treated)]
B[Kakao Talk & Story Usage]
A ==Control: Kakao Game Usage, Non-Kakao App Usage==> B
```

## STEP 1️⃣ Propensity Score Matching
The dataset consists of ***individual-level weekly panel data*** on app usage time collected from Android-based mobile devices. The sample includes ***849 users observed over a two-week period***.

There are 793 units in the control group (Anipang adoption = FALSE) and only 56 units in the treatment group (Anipang adoption = TRUE). The two groups differ significantly in terms of gender, age, education level, income, Kakao app usage, and non-Kakao app usage. **To ensure a more valid regression, propensity score matching (PSM) is conducted**.

![PSM](https://private-user-images.githubusercontent.com/208908471/452702524-efba9100-a73b-4dd6-a12c-4a236ca60e95.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDkzNTI2NjYsIm5iZiI6MTc0OTM1MjM2NiwicGF0aCI6Ii8yMDg5MDg0NzEvNDUyNzAyNTI0LWVmYmE5MTAwLWE3M2ItNGRkNi1hMTJjLTRhMjM2Y2E2MGU5NS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNjA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDYwOFQwMzEyNDZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0zMWZhNjdjY2M1NGFkZjJlMTlkYTBlYWVhYjU0NTk4YWFmMmRiMGU1NzM3MjE0NWJhMjA5NmNiNjk1MjYxMzA1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.uRC24vGXLPjTrNuG32xosaE1D4h9plTY6t0To7kFqlg)
![PSM](https://private-user-images.githubusercontent.com/208908471/452702561-269088b9-c547-48b5-9510-d573cadb32ae.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDkzNTI2NjYsIm5iZiI6MTc0OTM1MjM2NiwicGF0aCI6Ii8yMDg5MDg0NzEvNDUyNzAyNTYxLTI2OTA4OGI5LWM1NDctNDhiNS05NTEwLWQ1NzNjYWRiMzJhZS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNjA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDYwOFQwMzEyNDZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0yMTQ1ZjU5YmUwZGU4MmVlMzhiN2E4YmJhNmMwODU2OTdhZjNkODE4ZWUwMDM3MTkwYTk1MWUyM2VlY2RlNWU5JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.lI_NarD4J60-OYovnsVNRZYGNcyobzxjatIL3y6XYz8)

After the PSM, we saw substantial improvement in the statistics from raw to matched data, which means **all matched groups are well balanced** and can be considered appropriate for further analysis.


## STEP 2️⃣ Panel DID Regression Model 1
t_kakao_talk = β0 + αi (panel_id)i + δt (week) + **β1ii** +
                                         β2 t_kakao_story + β3 t_kakao_game + β4 t_non_kakao + uit

- panel_id: unit fixed effect
- week: time fixed effect
- ii: treatment variable (anipang adoption)
- t_kakao_talk: time using kakao talk
- t_kakao_story: time using kakao story

![PSM](https://private-user-images.githubusercontent.com/208908471/452702569-c7ee95df-ad1a-4ec8-b98e-b08df4c3866a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDkzNTI2NjYsIm5iZiI6MTc0OTM1MjM2NiwicGF0aCI6Ii8yMDg5MDg0NzEvNDUyNzAyNTY5LWM3ZWU5NWRmLWFkMWEtNGVjOC1iOThlLWIwOGRmNGMzODY2YS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNjA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDYwOFQwMzEyNDZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jZTkxMTI5OThmOTY1ZTU0ODNjZmU3ZWZjMzgyODlmNjU3YjI5ODI5YThhMWQyZGE3NjFmMDljZGVkZGIyZTAxJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.ip-cqG-DdJBwqbakqb1DmsWuDhmZJuRWlj5H4kX5d_s)

In ten models using ten different PSM groups, the coefficients of treatment variable are all insignificant at 5% significance level.

However, the coefficients of Kakao Story usage are significant, which means the usage time of Kakao Story has a siginificantly positive impact on the usage time of Kakao Talk.

**Result**: The adoption of Anipang ***DOES NOT have a significant impact*** on the usage time of Kakao Talk at very early adoption stage (first week). 


## STEP 3️⃣ Panel DID Regression Model 2
t_kakao_story = β0 + αi (panel_id)i + δt (week) + **β1ii** +
                                         β2 t_kakao_talk + β3 t_kakao_game + β4 t_non_kakao + uit

![PSM]([image/dummy2.png](https://private-user-images.githubusercontent.com/208908471/452702574-3ea895b4-61c1-4eb7-877a-51c8556ad1ab.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDkzNTI2NjYsIm5iZiI6MTc0OTM1MjM2NiwicGF0aCI6Ii8yMDg5MDg0NzEvNDUyNzAyNTc0LTNlYTg5NWI0LTYxYzEtNGViNy04NzdhLTUxYzg1NTZhZDFhYi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNjA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDYwOFQwMzEyNDZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT03MTkyZWNjOWUxNmQ3YTc0MzE2NGVhMTU3YTgzMjJkOTYxMTdkZmUyYzhkZGZjZTlmNTI4ZGYwZmJiMDhkNjQ0JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.7k_sE3nXHm8jvmXgHx9ryFFTOituGSvPDccHCVck4TM))

In ten models using ten different PSM groups, the coefficients of treatment variable are all insignificant at 5% significance level. The coefficients of kakao talk usage provide the same result, which means an increase in usage time of Kakao Talk will not lead to an increase in the usage time of Kakao Story.

**Result**: The adoption of Anipang ***DOES NOT have a significant impact*** on the usage time of Kakao Story at very early adoption stage (first week). 

## STEP 4️⃣ Conclusion
Despite Anipang’s viral success, we found no significant immediate increase in the usage time of Kakao Talk (communication) or Kakao Story (social networking). This suggests that viral app adoption does not necessarily lead to an instant rise in usage of other apps within the same platform ecosystem.