import swaggerJsdoc from 'swagger-jsdoc';

const options: swaggerJsdoc.Options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'CyberVerse API',
      version: '1.0.0',
      description: 'API documentation for CyberVerse Learning Simulator',
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: [
    './src/modules/**/*.routes.ts',
    './src/modules/**/*.controller.ts',
    './dist/modules/**/*.routes.js',
    './dist/modules/**/*.controller.js',
  ], // Path to the API docs
};

export const swaggerSpec = swaggerJsdoc(options);
