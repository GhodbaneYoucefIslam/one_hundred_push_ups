-- CreateTable
CREATE TABLE "user" (
    "id" SERIAL NOT NULL,
    "firstname" VARCHAR(50) NOT NULL,
    "lastname" VARCHAR(50) NOT NULL,
    "email" VARCHAR(50) NOT NULL,
    "ispublic" BOOLEAN NOT NULL,
    "hashed_password" VARCHAR(255) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "achievement" (
    "id" SERIAL NOT NULL,
    "type" VARCHAR(50) NOT NULL DEFAULT 'pushUps',
    "score" INTEGER NOT NULL,
    "day" TIMESTAMP(3) NOT NULL,
    "dailyRank" INTEGER,
    "rankChange" INTEGER,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "achievement_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_lastname_key" ON "user"("lastname");

-- AddForeignKey
ALTER TABLE "achievement" ADD CONSTRAINT "achievement_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
