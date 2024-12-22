import 'package:get/get.dart';
import 'translationConstants.dart';

class LocaleStrings extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {'en_US': englishDictionary, 'fr_FR': frenchDictionary};

  final englishDictionary = {
    // AppHome.dart
    notConnected: "Not connected",
    home: "Home",
    statsAndGoals: "Stats & Goals",
    leaderboard: "Leaderboard",
    settings: "Settings",
    lightModeKey: "Light\nmode",
    nightModeKey: "Night\nmode",
    logout: "Logout",
    login: "Login",
    resetDataQuestion: "Do you want to reset all your data (progress, stats)?",
    no: "No",
    yes: "Yes",

    // HomePage.dart
    homeExpression1: "Do your best",
    homeExpression2: "Keep going",
    homeExpression3: "You're doing great!",
    homeExpression4: "Keep grinding!",
    homeExpression5: "Almost done!",
    homeExpression6: "You've made it!",
    youHave: "You have",
    hours: "hours",
    minsAnd: "mins and",
    secondsToFinish: "seconds\n to finish your goal",
    doneForTheDay: "Done for the day!",
    addSet: "Add set",
    addNewSet: "Add new set",
    enterNumberOfReps: "Enter number of reps",
    emptyInputErrorMessage: "Input can't be empty",
    addReps: "Add reps",

    // MyGoalsPage.dart
    graph1Title: "Daily reps",
    graph2Title: "% of daily goal",
    graph3Title: "Reps per set",
    graph4Title: "Rank",
    statistics: "Statistics",
    streakMessage: "Current goal\ncompletion streak",
    yourAverage: "Your average is",
    repsPerDay: "reps per day",
    noAvailableStats: "No available stats yet",
    repsPerSet: "reps per set",
    pleaseLoginRankMessage: "Please login to access rank stats!",
    serverConnectionError: "Error connecting to server",
    rankStatsNotAvailable: "Rank stats not available",
    yourAverageRank: "Your average rank is",
    dailyGoal: "Daily goal",
    reps: "Reps",
    changeGoal: "Change goal",
    changeDailyGoal: "Change daily goal",
    enterDailyGoal: "Enter daily goal",
    change: "Change",

    // LeaderboardPage.dart
    forKey: "For",
    pleaseLoginLeaderboardMessage: "Please login to access leaderboard!",
    leaderboardNotAvailable: "Leaderboard not available",

    // SettingsPage.dart
    personal: "Personal",
    preferences: "Preferences",
    dataCenter: "Data center",
    aboutApp: "About App",

    // LoginPage.dart
    welcome: "Welcome to",
    loginNow: "Login now",
    enterEmail: "Enter your email",
    enterPassword: "Enter your password",
    passwordNotEmptyMessage: "Password cannot be empty",
    forgotPassword: "Forgot password?",
    verifyingCredentials: "Verifying credentials",
    invalidCredentials: "Invalid credentials!",
    or: "or",
    loggingIn: "Logging in",
    authenticationOf: "Authentication of",
    successfulWithId: "successful with id",
    notConnectedWithGoogleErrorMessage:
        "This user is not connected through Google. Please use email and password to log in.",
    googleFailed: "Google authentication failed. Please try again.",
    continueWithGoogle: "Continue with Google",
    dontHaveAccount: "Don’t have an account? ",
    signUpKey: "Sign up",
    continueWithoutAccount: "Continue without an account",
    verifyingEmail: "Verifying email",
    noAccountForEmailErrorMessage:
        "No account found for this email address. Please confirm your email.",
    pleaseProvideEmail: "Please provide your email address",
    confirm: "Confirm",
    proceedWithoutAccountWarningMessage:
        "Proceed without an account?\n You won't have access to all of 100PushUps's features",

    // SignUpPage.dart
    createAccount: "Create your account",
    firstName: "First name",
    fNameEmptyErrorMessage: "First name cannot be empty",
    lastName: "Last name",
    lNameEmptyErrorMessage: "Last name cannot be empty",
    emailField: "Email",
    passwordField: "Password",
    minCharactersErrorMessage: "Password cannot contain less than 4 characters",
    confirmPassword: "Confirm password",
    confirmedPasswordEmptyErrorMessage: "Confirmed password cannot be empty",
    iAccept: "I accept ",
    terms: "the terms ",
    and: "and ",
    conditions: "conditions ",
    pleaseConfirmPassword: "Please confirm your password",
    termsMustBeAcceptedErrorMessage: "Terms & conditions must be accepted",
    alreadyHaveAccount: "Already have an account?  ",
    emailUsedErrorMessage:
        "This email address is already used, please provide a different one",

    // CodeConfirmationPageForSignUp.dart
    failedSendingCodeErrorMessage:
        "Failed sending verification code, please go to previous page",
    verifyRegistrationEmail: "Verify email address",
    verificationCodeSent: "A verification code has been sent to",
    codeExpiresIn: "Code expires in",
    codeExpired: "Code expired click resend",
    resend: "Resend",
    incorrectOtpErrorMessage: "Incorrect OTP code!",

    // CodeConfirmationPageForForgotPassword.dart
    verifyPasswordReset: "Verify password resetting request",

    // ChangePasswordPage.dart
    changePasswordFor: "Change password for",
    changingPassword: "Changing password",
    changedPasswordFor: "Changed password for",
    errorChangingPasswordErrorMessage: "Error changing password",
    changePassword: "Change password",

    // OnboardingScreen.dart
    onboardingContent1: "Your partner in\nmastering your fitness\nchallenges",
    onboardingContent2: "Keep track of\nyour fitness goals",
    onboardingContent3: "See worldwide\nrankings!",
    onboardingContent4: "Would you like\nto create an account?",
    maybeLater: "Maybe later",
    back: "Back",
    // PersonalSettingsPage.dart
    yourAccount: "Your account",
    basicInfo: "Basic info",
    accountVisible: "Account visible in rankings leaderboard",
    processingRequest: "Processing request",
    modificationResults: "Modification results",
    saveChanges: "Save changes",
    notLoggedIn: "Not logged in",

    // PreferencesPage.dart
    inAppPreferences: "In-App Preferences",
    notifications: "Notifications",
    inactive: "Inactive",
    active: "Active",
    displayLanguage: "Display Language",
    currentLanguage: "Current Language",
    tapToChange: "Tap to change",

    // DataCenterPage.dart
    enterFileName: "Provide file name",
    importAndExport: "Import and export your In-App data",
    table: "Table",
    select: "Select",
    format: "Format",
    dateRangeKey: "Date range",
    saveTo: "Save to",
    fileNameKey: "File name",
    exportDataFrom: "Export data from",
    to: "to",
    pleaseVerifyExportOptions: "Please verify all of your export options",
    extensionAndFormatDontMatchErrorMessage:
        "File format and extension don't match",
    pleaseProvideBothFiles:
        "Please provide the data files for both\n the goals and sets tables in JSON or CSV formats",
    goalFile: "Goals data file",
    chooseFile: "Choose file",
    setsFile: "Sets data file",
    dataImportedSuccessfully: "Data imported successfully",
    importFailedMessage:
        "Import failed, please make sure file contents are formatted correctly",
    pleaseSelectTwoFiles: "Please select 2 appropriate files",
    export: "Export",
    import: "Import",
    loginToAccessRankErrorMessage: "Login first to access your rank data",
    retrievingData: "Retrieving data",
    dataExportedTo: "Data exported to",
    dataDeletionWarning:
        "Are you sure you want to continue ?\n All of your current In-App data will be deleted",
    /*
    goalsTableOption: "Goals",
    setsTableOption: "Sets",
    rankTableOption: "Rank",
    localStorageSaveOption: "Local storage",
    emailSaveOption: "Send to email",
    allTimeDateOption: "All time",
    customRangeDateOption: "Custom range",
    */

    // AboutApp.dart
    infoParagraph: "Welcome to One Hundred Push Ups, your ultimate fitness companion designed to help you achieve your strength goals through a structured and progressive push-up program. Our app is dedicated to providing you with personalized workout plans, tracking your progress, and keeping you motivated on your fitness journey.\n\n"
        "With features like a daily leaderboard, achievement tracking, and data management tools, One Hundred Push Ups ensures you stay on top of your game. Whether you're a beginner or an advanced athlete, our app adapts to your level, offering a unique experience tailored to your needs.\n\n"
        "We value your privacy and are committed to protecting your data. Please take a moment to review our Terms and Conditions and Privacy Policy. If you have any questions or feedback, feel free to contact us. We're here to support you every step of the way.\n\n"
        "Thank you for choosing One Hundred Push Ups. Let's get stronger together!",
    termsAndConditionsParagraph: "Terms and Conditions\n\n"
        "Welcome to One Hundred Push Ups. These terms and conditions outline the rules and regulations for the use of our application. By accessing and using this app, you accept and agree to be bound by the terms and conditions set forth below.\n\n"
        "1. Use of the App: You agree to use the app only for lawful purposes and in a way that does not infringe the rights of, restrict, or inhibit anyone else's use and enjoyment of the app.\n\n"
        "2. Privacy: Your privacy is important to us. Please read our Privacy Policy for information on how we collect, use, and disclose your personal data.\n\n"
        "3. Modifications to the Service: We reserve the right to modify or discontinue the app at any time, with or without notice, and without liability to you.\n\n"
        "4. Limitation of Liability: The app is provided on an 'as is' and 'as available' basis. We make no warranties, expressed or implied, and hereby disclaim and negate all other warranties.\n\n"
        "5. Governing Law: These terms and conditions are governed by and construed in accordance with the laws, and you irrevocably submit to the exclusive jurisdiction of the courts in that location.\n\n"
        "For any questions or inquiries about our terms and conditions contact us.",
    privacyPolicyParagraph: "Privacy Policy\n\n"
        "Welcome to One Hundred Push Ups. Your privacy is important to us. This Privacy Policy explains how we collect, use, and safeguard your information when you use our application.\n\n"
        "1. Information We Collect: We may collect personal information such as your name, email address, and workout data when you register and use the app.\n\n"
        "2. Use of Information: The information we collect is used to provide and improve our services, customize your experience, and communicate with you about updates and offers.\n\n"
        "3. Data Security: We implement a variety of security measures to maintain the safety of your personal information. However, no method of transmission over the Internet or electronic storage is 100% secure.\n\n"
        "4. Third-Party Services: We may employ third-party companies and individuals to facilitate our service. These third parties have access to your personal information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.\n\n"
        "5. Changes to This Privacy Policy: We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\n\n"
        "If you have any questions or concerns about our Privacy Policy, please contact us.",
    aboutSection: "About 100PushUps",
    termsAndConditionsSection: "Terms & Conditions",
    privacyPolicySection: "Privacy policy",

    // methods.dart
    emailEmptyErrorMessage: "Email cannot be empty",
    emailInvalidFormatErrorMessage: "Enter a valid email address",

    // LocalNotifications.dart
    notificationTitle: "Reminder",
    notificationMessage: "Don't forget to complete your daily goal"
  };

  final frenchDictionary = {
    // AppHome.dart
    notConnected: "Non connecté",
    home: "Accueil",
    statsAndGoals: "Statistiques et Objectifs",
    leaderboard: "Classement",
    settings: "Paramètres",
    lightModeKey: "Mode\nclair",
    nightModeKey: "Mode\nnuit",
    logout: "Déconnexion",
    login: "Connexion",
    resetDataQuestion:
        "Voulez-vous réinitialiser toutes vos données (progrès, statistiques) ?",
    no: "Non",
    yes: "Oui",

    // HomePage.dart
    homeExpression1: "Fais de ton mieux",
    homeExpression2: "Continue comme ça",
    homeExpression3: "Tu fais du bon travail !",
    homeExpression4: "Continue à te dépasser !",
    homeExpression5: "Presque terminé !",
    homeExpression6: "Tu as réussi !",
    youHave: "Tu as",
    hours: "heures",
    minsAnd: "minutes et",
    secondsToFinish: "secondes\n pour completer ton objectif",
    doneForTheDay: "Terminé pour aujourd'hui !",
    addSet: "Ajouter une série",
    addNewSet: "Ajouter une nouvelle série",
    enterNumberOfReps: "Entrer le nombre de répétitions",
    emptyInputErrorMessage: "Le champ ne peut pas être vide",
    addReps: "Ajouter les répétitions",

    // MyGoalsPage.dart
    graph1Title: "Répétitions / jour",
    graph2Title: "% de l'objectif",
    graph3Title: "Répétitions / série",
    graph4Title: "Classement",
    statistics: "Statistiques",
    streakMessage: "Série d'objectifs\nquotidiens atteints",
    yourAverage: "Ta moyenne est de",
    repsPerDay: "répétitions par jour",
    noAvailableStats: "Pas encore de statistiques disponibles",
    repsPerSet: "répétitions par série",
    pleaseLoginRankMessage:
        "Veuillez vous connecter pour accéder aux statistiques de classement !",
    serverConnectionError: "Erreur de connexion au serveur",
    rankStatsNotAvailable: "Statistiques de classement non disponibles",
    yourAverageRank: "Ton classement moyen est",
    dailyGoal: "Objectif quotidien",
    reps: "Répétitions",
    changeGoal: "Modifier l'objectif",
    changeDailyGoal: "Modifier l'objectif quotidien",
    enterDailyGoal: "Entrer l'objectif quotidien",
    change: "Modifier",

    // LeaderboardPage.dart
    forKey: "Pour",
    pleaseLoginLeaderboardMessage:
        "Veuillez vous connecter pour accéder au classement !",
    leaderboardNotAvailable: "Classement non disponible",

    // SettingsPage.dart
    personal: "Personnel",
    preferences: "Préférences",
    dataCenter: "Data Center",
    aboutApp: "À propos",

    // LoginPage.dart
    welcome: "Bienvenue sur",
    loginNow: "Se connecter maintenant",
    enterEmail: "Entrez votre e-mail",
    enterPassword: "Entrez votre mot de passe",
    passwordNotEmptyMessage: "Le mot de passe ne peut pas être vide",
    forgotPassword: "Mot de passe oublié ?",
    verifyingCredentials: "Vérification des informations d'identification",
    invalidCredentials: "Identifiants invalides !",
    or: "ou",
    loggingIn: "Connexion en cours",
    authenticationOf: "Authentification de",
    successfulWithId: "réussie avec l'ID",
    notConnectedWithGoogleErrorMessage:
        "Cet utilisateur n'est pas connecté via Google. Veuillez utiliser l'e-mail et le mot de passe pour vous connecter.",
    googleFailed: "Échec de l'authentification Google. Veuillez réessayer.",
    continueWithGoogle: "Continuer avec Google",
    dontHaveAccount: "Vous n'avez pas de compte ?",
    signUpKey: "S'inscrire",
    continueWithoutAccount: "Continuer sans compte",
    verifyingEmail: "Vérification de l'email",
    noAccountForEmailErrorMessage:
        "Aucun compte trouvé pour cette adresse e-mail. Veuillez confirmer votre e-mail.",
    pleaseProvideEmail: "Veuillez fournir votre adresse e-mail",
    confirm: "Confirmer",
    proceedWithoutAccountWarningMessage:
        "Continuer sans compte ?\n Vous n'aurez pas accès à toutes les fonctionnalités de 100PushUps",

    // SignUpPage.dart
    createAccount: "Créez votre compte",
    firstName: "Prénom",
    fNameEmptyErrorMessage: "Le prénom ne peut pas être vide",
    lastName: "Nom de famille",
    lNameEmptyErrorMessage: "Le nom de famille ne peut pas être vide",
    emailField: "E-mail",
    passwordField: "Mot de passe",
    minCharactersErrorMessage:
        "Le mot de passe ne peut pas contenir moins de 4 caractères",
    confirmPassword: "Confirmer le mot de passe",
    confirmedPasswordEmptyErrorMessage:
        "Le mot de passe confirmé ne peut pas être vide",
    iAccept: "J'accepte",
    terms: "les termes",
    and: "et",
    conditions: " les conditions",
    pleaseConfirmPassword: "Veuillez confirmer votre mot de passe",
    termsMustBeAcceptedErrorMessage:
        "Les termes et conditions doivent être acceptés",
    alreadyHaveAccount: "Vous avez déjà un compte ?",
    emailUsedErrorMessage:
        "Cette adresse e-mail est déjà utilisée, veuillez en fournir une autre",

// CodeConfirmationPageForSignUp.dart
    failedSendingCodeErrorMessage:
        "Échec de l'envoi du code de vérification, veuillez revenir à la page précédente",
    verifyRegistrationEmail: "Vérifier l'adresse e-mail",
    verificationCodeSent: "Un code de vérification a été envoyé à",
    codeExpiresIn: "Le code expire dans",
    codeExpired: "Code expiré, cliquez pour renvoyer",
    resend: "Renvoyer",
    incorrectOtpErrorMessage: "Code OTP incorrect !",

    // CodeConfirmationPageForForgotPassword.dart
    verifyPasswordReset:
        "Vérifier la demande de réinitialisation du mot de passe",

    // ChangePasswordPage.dart
    changePasswordFor: "Changer le mot de passe pour",
    changingPassword: "Changement du mot de passe",
    changedPasswordFor: "Mot de passe changé pour",
    errorChangingPasswordErrorMessage:
        "Erreur lors du changement du mot de passe",
    changePassword: "Changer le mot de passe",

    // OnboardingScreen.dart
    onboardingContent1: "Votre partenaire pour\nmaîtriser vos défis\nfitness",
    onboardingContent2: "Suivez vos\nobjectifs fitness",
    onboardingContent3: "Consultez les classements\nmondiaux !",
    onboardingContent4: "Souhaitez-vous\ncréer un compte ?",
    maybeLater: "Plus tard",
    back: "Retour",

    // PersonalSettingsPage.dart
    yourAccount: "Votre compte",
    basicInfo: "Informations de base",
    accountVisible: "Compte visible dans le classement",
    processingRequest: "Traitement de la demande",
    modificationResults: "Résultats de la modification",
    saveChanges: "Sauvegarder les modifications",
    notLoggedIn: "Non connecté",

    // PreferencesPage.dart
    inAppPreferences: "Préférences dans l'application",
    notifications: "Notifications",
    inactive: "Inactif",
    active: "Actif",
    displayLanguage: "Langue d'affichage",
    currentLanguage: "Langue actuelle",
    tapToChange: "Appuyez pour changer",

    // DataCenterPage.dart
    enterFileName: "Nom du fichier",
    importAndExport: "Importer et exporter vos données de l'application",
    table: "Table",
    select: "Choix",
    format: "Format",
    dateRangeKey: "Plage de dates",
    saveTo: "Enregistrer à",
    fileNameKey: "Nom",
    exportDataFrom: "Exporter les données de",
    to: "vers",
    pleaseVerifyExportOptions:
        "Veuillez vérifier toutes vos options d'exportation",
    extensionAndFormatDontMatchErrorMessage:
        "Le format du fichier et l'extension ne correspondent pas",
    pleaseProvideBothFiles:
        "Veuillez fournir les fichiers de données pour les\ntables objectifs et ensembles au format JSON ou CSV",
    goalFile: "Fichier objectives",
    chooseFile: "Choisir un fichier",
    setsFile: "Fichier répétitions",
    dataImportedSuccessfully: "Données importées avec succès",
    importFailedMessage:
        "Échec de l'importation, veuillez vous assurer que le contenu des fichiers est correctement formaté",
    pleaseSelectTwoFiles: "Veuillez sélectionner 2 fichiers appropriés",
    export: "Exporter",
    import: "Importer",
    loginToAccessRankErrorMessage:
        "Connectez-vous d'abord pour accéder à vos données de classement",
    retrievingData: "Récupération des données",
    dataExportedTo: "Données exportées vers",
    dataDeletionWarning:
        "Êtes-vous sûr de vouloir continuer ?\n Toutes vos données actuelles de l'application seront supprimées",
    /*
    goalsTableOption: "Objectifs",
    setsTableOption: "Séries",
    rankTableOption: "Classement",
    localStorageSaveOption: "Mon stockage",
    emailSaveOption: "e-mail",
    allTimeDateOption: "Tout",
    customRangeDateOption: "Plage",
    */

    // AboutApp.dart
    infoParagraph: "Bienvenue dans One Hundred Push Ups, votre compagnon de fitness ultime conçu pour vous aider à atteindre vos objectifs de force grâce à un programme structuré et progressif de pompes. Notre application est dédiée à vous fournir des plans d'entraînement personnalisés, à suivre vos progrès et à vous maintenir motivé tout au long de votre parcours fitness.\n\n"
        "Avec des fonctionnalités telles qu'un classement quotidien, le suivi des réalisations et des outils de gestion des données, One Hundred Push Ups vous permet de rester au top de votre forme. Que vous soyez un débutant ou un athlète avancé, notre application s'adapte à votre niveau, offrant une expérience unique adaptée à vos besoins.\n\n"
        "Nous valorisons votre vie privée et nous engageons à protéger vos données. Veuillez prendre un moment pour consulter nos Conditions Générales et notre Politique de Confidentialité. Si vous avez des questions ou des retours, n'hésitez pas à nous contacter. Nous sommes là pour vous soutenir à chaque étape de votre parcours.\n\n"
        "Merci d'avoir choisi One Hundred Push Ups. Devenons plus forts ensemble !",
    termsAndConditionsParagraph: "Conditions Générales\n\n"
        "Bienvenue dans One Hundred Push Ups. Ces conditions générales décrivent les règles et régulations d'utilisation de notre application. En accédant et en utilisant cette application, vous acceptez d'être lié par les termes et conditions décrits ci-dessous.\n\n"
        "1. Utilisation de l'application : Vous acceptez d'utiliser l'application uniquement à des fins légales et d'une manière qui n'enfreint pas les droits d'autrui, ne restreint pas ni n'empêche l'utilisation de l'application par d'autres utilisateurs.\n\n"
        "2. Vie privée : Votre vie privée est importante pour nous. Veuillez lire notre Politique de Confidentialité pour des informations sur la manière dont nous collectons, utilisons et divulguons vos données personnelles.\n\n"
        "3. Modifications du service : Nous nous réservons le droit de modifier ou d'interrompre l'application à tout moment, avec ou sans préavis, et sans responsabilité envers vous.\n\n"
        "4. Limitation de responsabilité : L'application est fournie sur une base 'tel quel' et 'selon disponibilité'. Nous ne garantissons aucune promesse, expresse ou implicite, et déclinons toutes autres garanties.\n\n"
        "5. Droit applicable : Ces termes et conditions sont régis et interprétés conformément aux lois en vigueur, et vous vous soumettez irrévocablement à la juridiction exclusive des tribunaux de cette juridiction.\n\n"
        "Pour toute question ou demande concernant nos conditions générales, contactez-nous.",
    privacyPolicyParagraph: "Politique de Confidentialité\n\n"
        "Bienvenue dans One Hundred Push Ups. Votre vie privée est importante pour nous. Cette Politique de Confidentialité explique comment nous collectons, utilisons et protégeons vos informations lorsque vous utilisez notre application.\n\n"
        "1. Informations que nous collectons : Nous pouvons collecter des informations personnelles telles que votre nom, votre adresse e-mail et vos données d'entraînement lorsque vous vous inscrivez et utilisez l'application.\n\n"
        "2. Utilisation des informations : Les informations que nous collectons sont utilisées pour fournir et améliorer nos services, personnaliser votre expérience et communiquer avec vous concernant les mises à jour et les offres.\n\n"
        "3. Sécurité des données : Nous mettons en place diverses mesures de sécurité pour assurer la protection de vos informations personnelles. Cependant, aucune méthode de transmission sur Internet ou de stockage électronique n'est 100% sécurisée.\n\n"
        "4. Services tiers : Nous pouvons faire appel à des entreprises et des individus tiers pour faciliter notre service. Ces tiers ont accès à vos informations personnelles uniquement pour exécuter ces tâches en notre nom et sont tenus de ne pas les divulguer ni les utiliser à d'autres fins.\n\n"
        "5. Modifications de cette Politique de Confidentialité : Nous pouvons mettre à jour notre Politique de Confidentialité de temps en temps. Nous vous informerons de tout changement en publiant la nouvelle Politique de Confidentialité sur cette page.\n\n"
        "Si vous avez des questions ou des préoccupations concernant notre Politique de Confidentialité, veuillez nous contacter.",
    aboutSection: "À propos de l'application",
    termsAndConditionsSection: "Les conditions Générales",
    privacyPolicySection: "Politique de Confidentialité",

    // methods.dart
    emailEmptyErrorMessage: "L'e-mail ne peut pas être vide",
    emailInvalidFormatErrorMessage: "Entrez une adresse e-mail valide",

    // LocalNotifications.dart
    notificationTitle: "Rappel",
    notificationMessage: "N'oubliez pas de completer votre objectif quotidien",
  };
}
