---
title: "The Art of NestJS Authentication: A Step-by-Step Guide for Beginners"
subtitle:
date: 2025-04-11T22:12:29+08:00
slug: b7d24cd
draft: true
authors: [Jereme]
description: A step-by-step implementation of an authentication system in NestJS
keywords: NestJS, tutorial, authentication, node.js
license: <a rel="license external nofollow noopener noreferrer" href="https://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">CC BY-NC-SA 4.0</a>
comment: false
weight: 0
tags:
  - development, tutorial, javascript
categories:
  - development
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRelated: false
hiddenFromFeed: false
summary: A step-by-step implementation of an authentication system in NestJS. Here we'll be implementing sign in, sign up, and JWT authentication guards as well.
resources:
  - name: featured-image
    src: images/featured-image.jpg
  - name: featured-image-preview
    src: images/featured-image-preview.jpg
toc: true
math: false
lightgallery: false
password:
message:
repost:
  enable: false
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---
This comprehensive guide will walk you through the step-by-step process of building a robust authentication system in NestJS, the progressive Node.js framework renowned for creating efficient and scalable server-side applications with TypeScript, built upon the solid foundation of Express.js.

In this tutorial, we will cover the essential aspects of user authentication, including:

- Project Initialization (Setup)
- User Registration (Sign Up)
- User Login (Sign In)
- Secure Password Handling (Password Hashing)
- Authentication (Authentication)


## Setup

To begin, we'll assume you have already set up a new NestJS project, as detailed in the official [NestJS documentation](https://docs.nestjs.com/). If you haven't done so yet, please refer to the documentation to create your base application before proceeding.

For our data persistence layer, we'll be utilizing MikroORM. We've chosen MikroORM for its elegant simplicity and stable API, making it an excellent choice for managing our user data. While NestJS's official documentation often features TypeORM, MikroORM offers a comparable and, in some aspects, more straightforward developer experience.

### Configuration

Before we start building our authentication logic, we need to configure our application to handle environment variables and data validation effectively. To achieve this, we'll install the following essential NestJS packages.
- `@nestjs/config`
- `class-transformer`
- `class-validator`

``` 
npm i -S @nestjs/config class-transformer class-validator
```

Update the App Module file in `src/app.module.ts` to initialize the configuration:

```tsx { title=app.module.ts hl_lines=["8-10"] }
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    ConfigModule.forRoot({ 
      isGlobal: true,
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
```

Then update  `src/main.ts` file to be able to use the `PORT` environment variable. Since we installed `class-validator`  we should add the `ValidationPipe` to check for validations later:

```tsx { title=app.module.ts hl_lines=[6,7]}
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule); 
  app.useGlobalPipes(new ValidationPipe()); 
  await app.listen(process.env.PORT ?? 3000, '0.0.0.0'); 
}
bootstrap();

```

We should now be able to create a `.env` file containing the following: 

``` 
PORT=3000
```

We should be able to change the running port when needed. Importing ConfigModule also allows the initialization of the `dotenv` package so we’ll be able to use `.env` files.

### Database Setup

To set up the database, we need to install the following packages: 

```bash
npm i -S passport @mikro-orm/core @mikro-orm/nestjs @mikro-orm/sqlite 
```

Also, the following dev dependencies for our migration scripts: 

```bash
npm i -D @mikro-orm/cli
```

In the root directory, create a file named `mikro-orm.config.ts` . This would handle our database configuration for the migration and application as well.

```tsx {title=mikro-orm.config.ts}
import { defineConfig } from '@mikro-orm/sqlite';
import * as dotenv from "dotenv";
dotenv.config();

export default defineConfig({
  entities: ['./dist/**/*.entity.js'],
  dbName: process.env.DATABASE_NAME,

  migrations: {
    path: './dist/migrations',
    pathTs: './src/migrations',
  },
});

```

Since this file is also called externally, we need to call `dotenv.config()` to ensure that our `.env` file is being read. Also, update our `.env` to include the `DATABASE_NAME` variable

```
PORT=3000
DATABASE_NAME=auth.sqlite
```

In the `app.module.ts` file, import the MikroOrm module. It should look something similar to this:

```tsx { hl_lines=[13] }
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { MikroOrmModule } from '@mikro-orm/nestjs';
import mikroOrmConfig from '../mikro-orm.config';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MikroOrmModule.forRoot(mikroOrmConfig), 
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

```

In our `package.json` , add the following  `scripts` entry to run our migration scripts later.

```
    "migration:up": "mikro-orm migration:up",
    "migration:down": "mikro-orm migration:down",
    "migration:list": "mikro-orm migration:list",
    "migration:create": "mikro-orm migration:create"
```

Now that we have our initial project setup, we should now be able to start working on our modules. 

## Planning our API

First, let’s plan our REST API Endpoints. 

`POST` **Sign Up User**

| Description | Create a new user |
| --- | --- |
| URL | `/auth/signup` |
| Auth Required | No |

**Request Body:**

| Paramater | Type  | Required |
| --- | --- | --- |
| username | string | true |
| password | string | true |
| fullName | string | true |

**Response 200**

```tsx
{
  "id": 1,
  "username": "string",
  "fullName": "string"
}
```

`POST` **Sign In User**

| Description | Login the user |
| --- | --- |
| URL | `/auth/signup` |
| Auth Required | No |

**Request Body**

| Paramater | Type  | Required |
| --- | --- | --- |
| username | string | true |
| password | string | true |

**Response 200**

```tsx
{
  "id": 1,
  "username": "string",
  "fullName": "string"
  "accessToken": "string"
}
```

`GET` User **Profile**

| Description | Get User Information |
| --- | --- |
| URL | `/user/profile` |
| Auth Required | Yes |

```tsx
{
  "id": 1,
  "username": "string",
  "fullName": "string"
}
```

Our app is going to be straightforward. The user should be able to sign up, sign in, and then gain access to the profile endpoint.

We won’t implement features like email verification or token refresh since it would be out of scope, and to keep things simple as well.

## Modules Setup

We’ll need to create the following modules

- users
- auth

In the terminal, run the following command to create the users module: 

```
nest g res users --no-spec
```

```
nest g res auth --no-spec
```

We’ve added  `--no-spec` since we won’t be creating unit tests for this tutorial. But you can remove it if you want to generate `.spec.ts` files for testing.

When prompted on the transport layer, choose `REST API`. Also, enter `No` when asked to generate CRUD entry points.

If successful, the following directories should be created under `src` 

- `src/users`
- `src/auth`

## Creating Our User Model

We’ll create our `User` model. Create the `entities` folder under `src/users`  then create a file named `user.entity.ts` 

```tsx
import { BeforeCreate, Entity, PrimaryKey, Property } from '@mikro-orm/core';
import * as bcrypt from 'bcrypt';

@Entity()
export class User {
  @PrimaryKey({ type: 'int', autoincrement: true })
  id: number;

  @Property({ unique: true })
  username: string;

  @Property({ type: 'string', hidden: true })
  password: string;

  @Property({ type: 'string', name: 'full_name', nullable: true })
  fullName: string;

  @Property({ type: 'Date', onCreate: () => new Date(), name: 'created_at' })
  public createdAt: Date | null;

  @Property({
    type: 'Date',
    onCreate: () => new Date(),
    onUpdate: () => new Date(),
    name: 'updated_at',
  })
  public updatedAt: Date | null;

  constructor(data?: Partial<User>) {
    Object.assign(this, data);
  }
}

```

Now let’s create a new migration script based on the model. In the terminal, enter the following 

```
npm run migration:create -- -n create_users
```

If successful, a new migration script in the `src/migrations` directory should be created with the following code similar to this:

```tsx
import { Migration } from '@mikro-orm/migrations';

export class Migration20250404051249_users extends Migration {

  override async up(): Promise<void> {
    this.addSql(`create table \`user\` (\`id\` integer not null primary key autoincrement, 
    \`username\` text not null, \`password\` text not null, 
    \`full_name\` text null, \`created_at\` datetime not null, \`updated_at\` datetime not null);`);
    this.addSql(`create unique index \`user_username_unique\` on \`user\` (\`username\`);`);
  }

}

```

Optionally, you can override the `down` method in case you need to revert your migration 

```tsx
  override async down(): Promise<void> {
    this.addSql('DROP table `user`');
  }
```

Now we have our migration script, run the following in the terminal:

```
npm run migration:up
```

If successful, an `auth.sqlite` file should be visible in the root directory. To open this, you can use the [SQLite cli tools](https://sqlite.org/cli.html) or the [SQLite browser](https://sqlitebrowser.org/). 

With these tools, you should be able to see the newly made table

## Implementing the API

### Creating the Create user DTO

We create a Data Transfer Object (DTO), which will be used to describe the data that will be validated. Create a file in `src/users/dto/create-user.dto.ts` and enter the following: 

```tsx
import { IsNotEmpty, IsString, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsNotEmpty()
  @IsString()
  username: string;

  @IsNotEmpty()
  @IsString()
  @MinLength(6)
  password: string;

  @IsNotEmpty()
  @IsString()
  fullName: string;
}

```

### Updating the Users Module

We’ll need to update the `users` module so that it interacts with the database. We’ll then integrate this with the `auth` module. This is to keep the authentication logic separate. 

In our `users.module.ts` , import the MikroOrm module we created earlier in our App Module.

```tsx
import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { User } from './entities/user.entity';
import { MikroOrmModule } from '@mikro-orm/nestjs';

@Module({
  controllers: [UsersController],
  providers: [UsersService],
  imports: [MikroOrmModule.forFeature([User])], // <--
  exports: [UsersService],
})
export class UsersModule {}

```

This should allow us to inject the User Repository into our `UsersService` provider.

In `users.service.ts`, copy the following content:

```tsx
import { InjectRepository } from '@mikro-orm/nestjs';
import { Injectable, NotFoundException } from '@nestjs/common';
import { User } from './entities/user.entity';
import { EntityRepository } from '@mikro-orm/sqlite';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: EntityRepository<User>,
  ) {}

  async create(userDetails: CreateUserDto): Promise<User> {
    const { username, password, fullName } = userDetails;
    const user: User = this.usersRepository.create({
      username,
      password,
      fullName,
    });

    await this.usersRepository.insert(user);

    return user;
  }
  
  async findOne(id: number): Promise<User> {
    const user = await this.usersRepository.findOne({ id });
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return user;
  }
  async findByUsername(username: string): Promise<User | null> {
    return await this.usersRepository.findOne({ username });
  }
}

```

We’ll be needing these methods later when we implement the authentication. Note that we are using `CreateUserDto` to provide type annotations.  

### Sign Up

Before we use our `UsersService` in our `auth` module, we’ll need to import the `users` module first. Update the `src/auth/auth.module.ts` file, then import `UsersModule`: 

```tsx
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from 'src/users/users.module';
 
@Module({
  controllers: [AuthController],
  providers: [AuthService],
  imports: [UsersModule],  // <-- 
})
export class AuthModule {}

```

We then create our service. Under  `src/auth/auth.service.ts` ,  inject the UsersService and add the method for Sign Up as well. 

```tsx
import { BadRequestException, Injectable } from '@nestjs/common';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { User } from '../users/entities/user.entity';
import { UsersService } from '../users/users.service';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService
  ) {}
  
  async signUp(signupDto: CreateUserDto): Promise<User> {
    const { username, password, fullName } = signupDto;
    const existing = await this.usersService.findByUsername(username);
    if (existing) {
      throw new BadRequestException('Username exists');
    }

    const hashed = await this.hashPassword(password);

    return await this.usersService.create({
      username,
      password: hashed,
      fullName,
    });
  }
  
  }
```

This code is not ready yet, as you might notice that we are calling a method called `hashPassword` . We’ll add this on the next step.

#### Password Encryption

For our password encryption, install the [bcrypt](https://www.npmjs.com/package/bcrypt) package

```
npm i -S bcrypt
```

Back in our `auth.service.ts` file, add the hashPassword function. 

```tsx
...
import { User } from '../users/entities/user.entity';
import * as bcrypt from 'bcrypt'; /// <--

@Injectable()
export class AuthService {
...

  async hashPassword(password: string): Promise<string> {
    const salt = await bcrypt.genSalt();

    return await bcrypt.hash(password, salt);
  }

}
```

We now have a service that contains the `signUp` method. Next, we’ll need to call this from the `AuthController`. We’ll also add the CreateUserDto to add some validation.

```tsx
import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { User } from 'src/users/entities/user.entity';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { Public } from './decorators/public.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}
 
  @Post('signup')
  async signUp(@Body() signupDto: CreateUserDto): Promise<User | null> {
    const user = await this.authService.signUp(signupDto);

    return user;
  }
}

```

You can test this using any tool such as Postman or EchoAPI. It should follow the Sign Up API we defined earlier. 

<!-- TODO add screenshot -->

### Sign In

For our User Sign in API, we need to create the DTO first for our validation.

`src/auth/dto/signin.dto.ts`

```tsx
import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class SignInDTO {
  @IsString()
  @IsNotEmpty()
  username: string;

  @IsString()
  @IsNotEmpty()
  password: string;
}

```

Next, we need to update our `auth.service.ts` file by adding the following code inside our `AuthService` class while implementing the SignInDto

```tsx
// ... 
// imports 

  export class AuthService {
  constructor(
    private readonly usersService: UsersService 
  ) {}
		
		// signUp function here

  async signIn(signInDTO: SignInDTO): Promise<User> {
    const { username, password } = signInDTO;

    const user = await this.usersService.findByUsername(username);
    if (!user) {
      throw new BadRequestException('Invalid Login Credentials');
    }

    const isPasswordValid = await this.comparePassword(password, user.password);

    if (!isPasswordValid) {
      throw new BadRequestException('Invalid Login Credentials');
    }

    return user;
  }
  
    async comparePassword(password: string, hashed: string): Promise<boolean> {
    const result = await bcrypt.compare(password, hashed);
    return result;
  }
  
  }
```

Then, in our controller, call the sign in method we created. 

```tsx

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}
  
  @Post('signin')
  async signIn(@Body() signInDTO: SignInDTO) {
    return await this.authService.signIn(signInDTO);
  }
  
  // @Post('signup')
  // ...
   
  
  }
```

At this point, we should test the sign-in API by using the same username and password we used in the sign-up API. 

#### Generating Access Tokens

As stated in our API specification for Sign In, this should return a Token. To implement this, we need to install the `@nestjs/jwt` package to support JWT manipulation:

```
npm i -S @nestjs/jwt
```

Next, in our `auth.module.ts`, import and initialize the module:

```tsx
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from 'src/users/users.module';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule, ConfigService } from '@nestjs/config';

@Module({
  controllers: [AuthController],
  providers: [AuthService],
  imports: [UsersModule, JwtModule.registerAsync({ // <--
    imports: [ConfigModule],
    inject: [ConfigService],
    useFactory: (configService: ConfigService)=>{
      return {
        secret: configService.getOrThrow('JWT_SECRET')
      };
    }
  })],  // <--
})
export class AuthModule {}

```

Also, you might notice that we are using an environment variable called `JWT_SECRET`, so be sure to update our `.env` file: 

```
JWT_SECRET=yoursecretvalue
```

You should be able to inject `JWTService` in our `AuthService` provider. 

In the `auth.service.ts` file, update the following : 

```tsx
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService, // <-- 
  ) {}

// ...

 async signIn(signInDTO: SignInDTO) {
    const { username, password } = signInDTO;

    const user = await this.usersService.findByUsername(username);
    if (!user) {
      throw new BadRequestException('Invalid Login Credentials');
    }

    const isPasswordValid = await this.comparePassword(password, user.password);

    if (!isPasswordValid) {
      throw new BadRequestException('Invalid Login Credentials');
    }

    const payload = {
      sub: user.id,
      username: user.username,
    };
    const accessToken = await this.jwtService.signAsync(payload); // <--

    return { // <--
      ...user,
      accessToken, 
    };
  }

}
```

### Implementing an Authentication Guard

Now that users can successfully log in, the crucial next step is to secure our API endpoints by implementing an authentication guard. This will ensure that only authenticated users can access protected resources. A widely adopted and effective method for verifying the authenticity of API requests and securely transmitting user information is through the use of JSON Web Tokens (JWT).

JWTs offer a stateless and self-contained way to represent claims securely between parties. When a user logs in, the server issues a JWT that contains information about the user. This token is then sent back to the client (e.g., a web browser or mobile application), which subsequently includes it in the headers of subsequent requests to protected API endpoints. The server can then verify the authenticity and integrity of the token without needing to query a database for each request.

To implement JWT-based authentication in our NestJS application, we'll need to install the necessary packages:

```
npm i -S @nestjs/passport passport-jwt
npm i -D @types/passport-jwt
```

Here's a brief explanation of these packages:

- `@nestjs/passport`
- `passport-jwt`
- `@types/passport-jwt`

We will be leveraging [Passport.js](http://www.passportjs.org/), a well-established and mature Node.js authentication middleware. Its extensive ecosystem and robust features make it a reliable choice for handling authentication in various scenarios. The `@nestjs/passport` module simplifies its integration within our NestJS application.

We’ll then have to create a strategy first. This is needed in order to configure our authentication scheme. 

```tsx
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.getOrThrow("JWT_SECRET") ,
    });
  }

  async validate(payload: any) {
    return { userId: payload.sub, username: payload.username };
  }
}

```

source: https://docs.nestjs.com/recipes/passport#jwt-functionality

Save this under `src/auth/strategies/jwt.strategy.ts`

Next create the authentication guard:  `src/auth/guards/jwt-auth.guard.ts`

```
import { ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
}

```

#### Making the authentication guard global

To establish a robust security baseline for our application, we'll implement a global authentication guard. This design pattern enforces authentication checks at the application level, meaning that *every* incoming request to our API will, by default, be intercepted and required to present a valid JWT. This *secure by default* strategy minimizes the risk of accidentally exposing new endpoints without proper authorization.

Update the `app.module.ts` to implement our global authentication guard:

```tsx
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { MikroOrmModule } from '@mikro-orm/nestjs';
import mikroOrmConfig from '../mikro-orm.config';
import { APP_GUARD } from '@nestjs/core';
import { JwtAuthGuard } from './auth/guards/jwt-auth.guard';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MikroOrmModule.forRoot(mikroOrmConfig),
    AuthModule,
    UsersModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_GUARD,  // Globally apply the JwtAuthGuard
      useClass: JwtAuthGuard, // <--
    },
  ],
})
export class AppModule {}

```

By registering `JwtAuthGuard` as a global guard using the `APP_GUARD` token, we're instructing NestJS's request pipeline to execute this guard *before* any route handler is invoked. Think of it as a security checkpoint at the entry of our application. Every request must pass this check (i.e., provide a valid JWT) to proceed to the intended controller and method.

While a global guard provides excellent default security, it presents a challenge for publicly accessible routes like our `sign-up` and `sign-in` endpoints. These entry points *must* be reachable without any prior authentication. Forcing a JWT check on these routes would create a 'chicken and egg' problem – users can't obtain a JWT to access the very endpoints needed to get one. To solve this, we'll employ a common technique: creating a custom decorator to explicitly mark routes that should bypass the global authentication.

#### Creating the Public Decorator

The `@Public()` decorator leverages NestJS's metadata system. By using `SetMetadata`, we're essentially attaching a key-value pair (`{ isPublic: true }`) to the route handler's metadata. This metadata can then be inspected by our `JwtAuthGuard` to conditionally bypass the authentication check. This approach keeps our authentication logic centralized within the guard while allowing flexible control over individual route accessibility.

Create a new decorator under `src/auth/decorators/public.decorator.ts` 

```tsx
import { SetMetadata } from '@nestjs/common';

export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

```

Back to our authentication guard `jwt-auth.guard.ts` file, update it using the following code: 

```tsx
import { ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
 // <--
    constructor(private reflector: Reflector) {
        super();
      }
    
      canActivate(context: ExecutionContext) {
        const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
          context.getHandler(),
          context.getClass(),
        ]);
        
        // If the route is public, allow access without authentication
        if (isPublic) {
          return true;
        }
        
        // Otherwise, enforce the default JWT authentication
        return super.canActivate(context);
      }
   // <--
}

```

Within the `canActivate` method of our `JwtAuthGuard`, we now utilize the `Reflector` service – a powerful tool in NestJS for accessing route metadata. We specifically look for the `isPublic` key, checking both the handler (the specific route method) and the controller. If this metadata is present and set to `true`, the guard immediately returns `true`, allowing the request to proceed without a JWT. If the `@Public()` decorator is not present, the execution falls back to `super.canActivate(context)`, which triggers the standard JWT verification process provided by `passport-jwt`.

Now moving to our AuthController `auth.controller.ts`,  add the public decorators before the controller methods for sign-up and sign-in.

```tsx
import { CreateUserDto } from '../users/dto/create-user.dto';
import { Public } from './decorators/public.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('signup')
  @Public() //<--
  async signUp(@Body() signupDto: CreateUserDto): Promise<User | null> {
    const user = await this.authService.signUp(signupDto);

    return user;
  }

  @Post('signin')
  @Public() //<--
  async signIn(@Body() signInDTO: SignInDTO) {
    return await this.authService.signIn(signInDTO);
  }
}

```

By strategically placing the `@Public()` decorator above our `signUp` and `signIn` methods in the `AuthController`, we're explicitly telling our global `JwtAuthGuard` to skip the authentication check for these specific routes. This ensures that new users can register and existing users can log in without needing a pre-existing JWT.

This provides a robust and flexible security model for our application. We achieve a secure-by-default posture while still allowing controlled public access to essential endpoints. As our application grows, any new route will automatically be protected, and we can selectively make routes public using our custom decorator, ensuring consistent and intentional security practices.

### Profile

With our authentication guard in place, we can now create our first protected API endpoint: the user profile. This endpoint will require a valid authentication token and, upon successful verification, will retrieve and return information about the currently logged-in user.

Assuming you have a `UsersModule` and a corresponding `UsersController` (as established in previous steps), we'll now update this controller to implement the profile endpoint. This endpoint will leverage the `findOne` function we previously defined in the `UsersService` to fetch user details.

`users.controller.ts`

```tsx
import { Controller, Get, Req } from '@nestjs/common';
import { UsersService } from './users.service';
import { User } from './entities/user.entity';
import { JWTPayload } from '../auth/interfaces/jwt-payload.interface';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('profile')
  async profile(@Req() req): Promise<User> {
    const { userId } = req.user as JWTPayload;
    return this.usersService.findOne(userId);
  }
}

```

As part of the JWT authentication process, Passport.js, specifically the `passport-jwt` strategy we implemented, automatically decodes the JWT payload and attaches it to the `request` object under the `user` property. This payload typically contains information about the authenticated user, such as their `userId`, which we can then access in our controller.

#### Testing

To test this new protected endpoint, you'll need a valid access token. Follow these steps:

1. First, make a `POST` request to your `/auth/signin` endpoint with valid user credentials.
2. Upon successful login, the server should return an access token.
3. Copy this access token.
4. In Postman or a similar API testing tool, make a `GET` request to the `/users/profile` endpoint.
5. In the request headers, add an `Authorization` header with the value `Bearer <your_access_token>` (replace `<your_access_token>` with the token you copied).
*Alternatively, under auth, you can select Bearer tokens and just paste the access token without needing to add the `Bearer` prefix.*


{{< image src="test_profile.png" caption="Example testing on profile endpoint"  >}}



# Conclusion

In this guide, we implemented a basic authentication system using NestJS and MikroORM. We covered setting up the environment, configuring the database, creating a user model, and implementing sign-up, sign-in, and profile endpoints. While the system is simple and doesn't include advanced features like email verification or token refresh, it's a solid foundation for building more complex auth workflows.

Feel free to expand on this by adding features such as role-based access control, refresh tokens, or integration with external identity providers.

You can find the complete source code for this project here: [NestJS Auth Example](https://github.com/jeremejazz/nestjs-auth-example)

{{< admonition type=note title="Resource" open=true >}}
Cover Photo by [Jason Dent](https://unsplash.com/@jdent?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash) on [Unsplash](https://unsplash.com/photos/black-and-silver-door-knob-3wPJxh-piRw?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)
 
{{< /admonition >}}
