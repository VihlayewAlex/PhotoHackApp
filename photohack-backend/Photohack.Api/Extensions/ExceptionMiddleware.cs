//-----------------------------------------------------------------------
// <copyright file="ExceptionMiddleWare.cs" company="Space Rabbits">
//     Copyright (c) Space Rabbits. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

using System;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Photohack.Api.Models;

namespace Photohack.Api.Extensions
{
    /// <summary>
    /// Exception middleware
    /// </summary>
    public class ExceptionMiddleWare
    {
        /// <summary>
        /// The next
        /// </summary>
        private readonly RequestDelegate _next;

        /// <summary>
        /// Initializes a new instance of the <see cref="ExceptionMiddleWare"/> class.
        /// </summary>
        /// <param name="next">The next.</param>
        public ExceptionMiddleWare(RequestDelegate next)
        {
            _next = next;
        }

        /// <summary>
        /// Invokes the asynchronous.
        /// </summary>
        /// <param name="httpContext">The HTTP context.</param>
        /// <returns>
        /// The method is void.
        /// </returns>
        public async Task InvokeAsync(HttpContext httpContext)
        {
            try
            {
                await _next(httpContext);
            }
            catch (Exception ex)
            {
                await HandleExceptionAsync(httpContext, ex);
            }
        }

        /// <summary>
        /// Handles the exception asynchronous.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="exception">The exception.</param>
        /// <returns>
        /// The method is void.
        /// </returns>
        private static Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;

            ApiResponse error = new ApiResponse
            {
                Result = false,
                Errors = new string[]
                {
                    "Just don’t worry, I’m already calling my developers to address this problem",
                    exception.Message?.ToString(),
                    exception.InnerException?.ToString()
                }
            };

            return context.Response.WriteAsync(error.ToString());
        }
    }
}
